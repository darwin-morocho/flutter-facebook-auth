#include "webview_host.h"

#include <windows.h>

#include <WebView2.h>
#include <objbase.h>
#include <wrl.h>

#include <algorithm>
#include <string>

namespace facebook_auth_desktop {

namespace {

using Microsoft::WRL::Callback;
using Microsoft::WRL::ComPtr;

constexpr wchar_t kWindowClassName[] = L"FacebookAuthDesktopWebViewWindow";
constexpr wchar_t kWindowTitle[] = L"Log in with Facebook";

// Matches the window size used by the macOS implementation. These are
// logical pixels and get scaled to the monitor DPI below.
constexpr int kWindowWidth = 980;
constexpr int kWindowHeight = 720;
constexpr UINT kDefaultDpi = 96;

// GetDpiForWindow is resolved at runtime so the plugin still compiles against
// Windows SDKs that predate it, falling back to an unscaled window.
UINT WindowDpi(HWND window) {
  using GetDpiForWindowPtr = UINT(WINAPI*)(HWND);
  static auto get_dpi_for_window = reinterpret_cast<GetDpiForWindowPtr>(
      ::GetProcAddress(::GetModuleHandleW(L"user32.dll"), "GetDpiForWindow"));
  if (get_dpi_for_window != nullptr && window != nullptr) {
    UINT dpi = get_dpi_for_window(window);
    if (dpi != 0) {
      return dpi;
    }
  }
  return kDefaultDpi;
}

// WebView2 returns strings that the caller must release with CoTaskMemFree.
class CoTaskMemString {
 public:
  CoTaskMemString() = default;
  ~CoTaskMemString() { ::CoTaskMemFree(value_); }

  CoTaskMemString(const CoTaskMemString&) = delete;
  CoTaskMemString& operator=(const CoTaskMemString&) = delete;

  LPWSTR* put() { return &value_; }
  LPCWSTR get() const { return value_; }
  bool empty() const { return value_ == nullptr; }
  std::wstring str() const {
    return value_ != nullptr ? std::wstring(value_) : std::wstring();
  }

 private:
  LPWSTR value_ = nullptr;
};

std::wstring Utf16FromUtf8(const std::string& utf8) {
  if (utf8.empty()) {
    return std::wstring();
  }
  int size = ::MultiByteToWideChar(CP_UTF8, 0, utf8.data(),
                                   static_cast<int>(utf8.length()), nullptr, 0);
  if (size <= 0) {
    return std::wstring();
  }
  std::wstring utf16(size, L'\0');
  ::MultiByteToWideChar(CP_UTF8, 0, utf8.data(),
                        static_cast<int>(utf8.length()), utf16.data(), size);
  return utf16;
}

std::string Utf8FromUtf16(const std::wstring& utf16) {
  if (utf16.empty()) {
    return std::string();
  }
  int size = ::WideCharToMultiByte(CP_UTF8, 0, utf16.data(),
                                   static_cast<int>(utf16.length()), nullptr, 0,
                                   nullptr, nullptr);
  if (size <= 0) {
    return std::string();
  }
  std::string utf8(size, '\0');
  ::WideCharToMultiByte(CP_UTF8, 0, utf16.data(),
                        static_cast<int>(utf16.length()), utf8.data(), size,
                        nullptr, nullptr);
  return utf8;
}

// WebView2 needs a writable folder for its profile. The executable directory
// (the default) is often read-only for installed apps, so use LOCALAPPDATA.
std::wstring UserDataFolder() {
  wchar_t local_app_data[MAX_PATH] = {};
  DWORD length = ::GetEnvironmentVariableW(L"LOCALAPPDATA", local_app_data,
                                           MAX_PATH);
  if (length == 0 || length >= MAX_PATH) {
    return std::wstring();  // Let WebView2 fall back to its own default.
  }

  std::wstring folder(local_app_data, length);
  folder.append(L"\\facebook_auth_desktop");
  ::CreateDirectoryW(folder.c_str(), nullptr);
  return folder;
}

}  // namespace

WebViewHost::WebViewHost() = default;

WebViewHost::~WebViewHost() {
  *alive_ = false;
  if (controller_) {
    controller_->Close();
    controller_.Reset();
  }
  webview_.Reset();
  if (window_) {
    HWND window = window_;
    window_ = nullptr;
    ::SetWindowLongPtrW(window, GWLP_USERDATA, 0);
    ::DestroyWindow(window);
  }
  if (owner_ && owner_was_enabled_) {
    ::EnableWindow(owner_, TRUE);
  }
}

const wchar_t* WebViewHost::WindowClass() {
  static bool registered = false;
  if (!registered) {
    WNDCLASSEXW window_class = {};
    window_class.cbSize = sizeof(WNDCLASSEXW);
    window_class.style = CS_HREDRAW | CS_VREDRAW;
    window_class.lpfnWndProc = WebViewHost::WndProc;
    window_class.hInstance = ::GetModuleHandleW(nullptr);
    window_class.hCursor = ::LoadCursorW(nullptr, IDC_ARROW);
    window_class.hbrBackground = ::CreateSolidBrush(RGB(255, 255, 255));
    window_class.lpszClassName = kWindowClassName;
    ::RegisterClassExW(&window_class);
    registered = true;
  }
  return kWindowClassName;
}

void WebViewHost::Show(HWND owner,
                       const std::string& url,
                       const std::string& target_uri_fragment,
                       CompletionHandler on_complete,
                       ErrorHandler on_error) {
  owner_ = owner;
  pending_url_ = Utf16FromUtf8(url);
  target_uri_fragment_ = Utf16FromUtf8(target_uri_fragment);
  on_complete_ = std::move(on_complete);
  on_error_ = std::move(on_error);

  const double scale =
      static_cast<double>(WindowDpi(owner_)) / static_cast<double>(kDefaultDpi);
  int width = static_cast<int>(kWindowWidth * scale);
  int height = static_cast<int>(kWindowHeight * scale);

  // That size is comfortable on a large display but swallows a small one, so
  // keep the dialog inside the work area of the monitor it lands on. min/max
  // are parenthesised because a host app need not define NOMINMAX.
  MONITORINFO monitor = {};
  monitor.cbSize = sizeof(monitor);
  const bool have_monitor =
      ::GetMonitorInfoW(::MonitorFromWindow(owner_ != nullptr
                                                ? owner_
                                                : ::GetDesktopWindow(),
                                            MONITOR_DEFAULTTONEAREST),
                        &monitor) != FALSE;
  if (have_monitor) {
    const int work_width =
        static_cast<int>(monitor.rcWork.right - monitor.rcWork.left);
    const int work_height =
        static_cast<int>(monitor.rcWork.bottom - monitor.rcWork.top);
    width = (std::min)(width, work_width * 9 / 10);
    height = (std::min)(height, work_height * 9 / 10);
  }

  // Center the dialog over the host window when there is one, then keep the
  // whole of it on screen.
  int x = CW_USEDEFAULT;
  int y = CW_USEDEFAULT;
  RECT owner_rect;
  if (owner_ != nullptr && ::GetWindowRect(owner_, &owner_rect)) {
    x = owner_rect.left + ((owner_rect.right - owner_rect.left) - width) / 2;
    y = owner_rect.top + ((owner_rect.bottom - owner_rect.top) - height) / 2;
  } else if (have_monitor) {
    x = monitor.rcWork.left +
        ((monitor.rcWork.right - monitor.rcWork.left) - width) / 2;
    y = monitor.rcWork.top +
        ((monitor.rcWork.bottom - monitor.rcWork.top) - height) / 2;
  }
  if (have_monitor && x != CW_USEDEFAULT) {
    // RECT members are LONG; keep both sides of min/max the same type.
    const int work_left = static_cast<int>(monitor.rcWork.left);
    const int work_top = static_cast<int>(monitor.rcWork.top);
    const int work_right = static_cast<int>(monitor.rcWork.right);
    const int work_bottom = static_cast<int>(monitor.rcWork.bottom);
    x = (std::max)(work_left, (std::min)(x, work_right - width));
    y = (std::max)(work_top, (std::min)(y, work_bottom - height));
  }

  // No minimize/maximize box: this is a modal dialog, not a document window.
  DWORD style = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME;
  window_ = ::CreateWindowExW(0, WindowClass(), kWindowTitle, style, x, y,
                              width, height, owner_, nullptr,
                              ::GetModuleHandleW(nullptr), this);

  if (!window_) {
    Fail("window_creation_failed",
         "Could not create the Facebook login window.");
    return;
  }

  // Emulate the macOS `presentAsModalWindow` behaviour.
  if (owner_ != nullptr) {
    owner_was_enabled_ = ::IsWindowEnabled(owner_) != FALSE;
    ::EnableWindow(owner_, FALSE);
  }

  CreateWebView();
}

void WebViewHost::CreateWebView() {
  std::wstring user_data_folder = UserDataFolder();
  std::shared_ptr<bool> alive = alive_;

  HRESULT hr = ::CreateCoreWebView2EnvironmentWithOptions(
      nullptr, user_data_folder.empty() ? nullptr : user_data_folder.c_str(),
      nullptr,
      Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
          [this, alive](HRESULT result,
                        ICoreWebView2Environment* env) -> HRESULT {
            if (!*alive) {
              return S_OK;
            }
            if (FAILED(result) || env == nullptr) {
              Fail("webview2_unavailable",
                   "Failed to create the WebView2 environment. Make sure the "
                   "Microsoft Edge WebView2 Runtime is installed.");
              CloseWindow();
              return S_OK;
            }

            return env->CreateCoreWebView2Controller(
                window_,
                Callback<
                    ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>(
                    [this, alive](
                        HRESULT controller_result,
                        ICoreWebView2Controller* controller) -> HRESULT {
                      if (!*alive) {
                        return S_OK;
                      }
                      if (FAILED(controller_result) || controller == nullptr) {
                        Fail("webview2_unavailable",
                             "Failed to create the WebView2 controller.");
                        CloseWindow();
                        return S_OK;
                      }
                      return OnControllerCreated(controller);
                    })
                    .Get());
          })
          .Get());

  if (FAILED(hr)) {
    // The most common cause is a missing WebView2 Runtime.
    Fail("webview2_unavailable",
         "The Microsoft Edge WebView2 Runtime is not available on this "
         "machine. Install it from "
         "https://developer.microsoft.com/microsoft-edge/webview2/");
    CloseWindow();
  }
}

HRESULT WebViewHost::OnControllerCreated(ICoreWebView2Controller* controller) {
  controller_ = controller;
  controller_->get_CoreWebView2(&webview_);
  if (!webview_) {
    Fail("webview2_unavailable", "Failed to obtain the WebView2 instance.");
    CloseWindow();
    return S_OK;
  }

  // The controller is created while the window is still hidden, and WebView2
  // starts it hidden to match. Showing the window later does not flip it back,
  // so without this the dialog renders blank however well the page loads.
  controller_->put_IsVisible(TRUE);

  // The login dialog is a one-shot flow; there is nothing to gain from a
  // context menu or the dev tools, and both are distracting to end users.
  ComPtr<ICoreWebView2Settings> settings;
  if (SUCCEEDED(webview_->get_Settings(&settings)) && settings) {
    settings->put_AreDefaultContextMenusEnabled(FALSE);
    settings->put_AreDevToolsEnabled(FALSE);
    settings->put_IsStatusBarEnabled(FALSE);
  }

  // Start from a clean session, like `clearCookies()` does on macOS, so a
  // previous login never silently re-authenticates the user.
  ComPtr<ICoreWebView2_2> webview2;
  if (SUCCEEDED(webview_.As(&webview2)) && webview2) {
    ComPtr<ICoreWebView2CookieManager> cookie_manager;
    if (SUCCEEDED(webview2->get_CookieManager(&cookie_manager)) &&
        cookie_manager) {
      cookie_manager->DeleteAllCookies();
    }
  }

  std::shared_ptr<bool> alive = alive_;
  EventRegistrationToken token;

  webview_->add_NavigationStarting(
      Callback<ICoreWebView2NavigationStartingEventHandler>(
          [this, alive](ICoreWebView2* sender,
                        ICoreWebView2NavigationStartingEventArgs* args)
              -> HRESULT {
            if (!*alive) {
              return S_OK;
            }
            CoTaskMemString uri;
            if (FAILED(args->get_Uri(uri.put())) || uri.empty()) {
              return S_OK;
            }
            if (InterceptNavigation(uri.str())) {
              args->put_Cancel(TRUE);
            }
            return S_OK;
          })
          .Get(),
      &token);

  // Facebook occasionally hands the redirect to a popup; keep it in this
  // window so the interception above still sees it.
  webview_->add_NewWindowRequested(
      Callback<ICoreWebView2NewWindowRequestedEventHandler>(
          [this, alive](ICoreWebView2* sender,
                        ICoreWebView2NewWindowRequestedEventArgs* args)
              -> HRESULT {
            if (!*alive) {
              return S_OK;
            }
            CoTaskMemString uri;
            if (SUCCEEDED(args->get_Uri(uri.put())) && !uri.empty()) {
              args->put_Handled(TRUE);
              if (!InterceptNavigation(uri.str())) {
                webview_->Navigate(uri.get());
              }
            }
            return S_OK;
          })
          .Get(),
      &token);

  webview_->add_WindowCloseRequested(
      Callback<ICoreWebView2WindowCloseRequestedEventHandler>(
          [this, alive](ICoreWebView2* sender, IUnknown* args) -> HRESULT {
            if (!*alive) {
              return S_OK;
            }
            CloseWindow();
            return S_OK;
          })
          .Get(),
      &token);

  ResizeWebView();
  webview_->Navigate(pending_url_.c_str());

  ::ShowWindow(window_, SW_SHOW);
  ::UpdateWindow(window_);
  ::SetForegroundWindow(window_);
  return S_OK;
}

bool WebViewHost::InterceptNavigation(const std::wstring& url) {
  if (target_uri_fragment_.empty() ||
      url.find(target_uri_fragment_) == std::wstring::npos) {
    return false;
  }
  Complete(Utf8FromUtf16(url));
  CloseWindow();
  return true;
}

void WebViewHost::Complete(std::optional<std::string> callback_url) {
  if (responded_) {
    return;
  }
  responded_ = true;
  if (on_complete_) {
    CompletionHandler handler = std::move(on_complete_);
    on_complete_ = nullptr;
    on_error_ = nullptr;
    handler(std::move(callback_url));
  }
}

void WebViewHost::Fail(const std::string& code, const std::string& message) {
  if (responded_) {
    return;
  }
  responded_ = true;
  if (on_error_) {
    ErrorHandler handler = std::move(on_error_);
    on_complete_ = nullptr;
    on_error_ = nullptr;
    handler(code, message);
  }
}

void WebViewHost::ResizeWebView() {
  if (!controller_ || !window_) {
    return;
  }
  RECT bounds;
  ::GetClientRect(window_, &bounds);
  controller_->put_Bounds(bounds);
}

void WebViewHost::CloseWindow() {
  if (window_) {
    ::PostMessageW(window_, WM_CLOSE, 0, 0);
  }
}

LRESULT CALLBACK WebViewHost::WndProc(HWND window,
                                      UINT message,
                                      WPARAM wparam,
                                      LPARAM lparam) noexcept {
  if (message == WM_NCCREATE) {
    auto* create_struct = reinterpret_cast<CREATESTRUCTW*>(lparam);
    ::SetWindowLongPtrW(window, GWLP_USERDATA,
                       reinterpret_cast<LONG_PTR>(create_struct->lpCreateParams));
  } else if (auto* host = reinterpret_cast<WebViewHost*>(
                 ::GetWindowLongPtrW(window, GWLP_USERDATA))) {
    return host->HandleMessage(window, message, wparam, lparam);
  }
  return ::DefWindowProcW(window, message, wparam, lparam);
}

LRESULT WebViewHost::HandleMessage(HWND window,
                                   UINT message,
                                   WPARAM wparam,
                                   LPARAM lparam) noexcept {
  switch (message) {
    case WM_SIZE:
      ResizeWebView();
      return 0;
    case WM_DESTROY: {
      // Re-enable the app window first so focus lands back on it.
      if (owner_ && owner_was_enabled_) {
        ::EnableWindow(owner_, TRUE);
        ::SetActiveWindow(owner_);
        owner_was_enabled_ = false;
      }
      // A window closed without an intercepted redirect means the user
      // dismissed the dialog, which the Dart side reports as "cancelled".
      Complete(std::nullopt);
      if (controller_) {
        controller_->Close();
        controller_.Reset();
      }
      webview_.Reset();
      window_ = nullptr;
      return 0;
    }
    default:
      break;
  }
  return ::DefWindowProcW(window, message, wparam, lparam);
}

}  // namespace facebook_auth_desktop
