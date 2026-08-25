#ifndef FLUTTER_PLUGIN_FACEBOOK_AUTH_DESKTOP_WEBVIEW_HOST_H_
#define FLUTTER_PLUGIN_FACEBOOK_AUTH_DESKTOP_WEBVIEW_HOST_H_

#include <windows.h>

#include <WebView2.h>
#include <wrl.h>

#include <functional>
#include <memory>
#include <optional>
#include <string>

namespace facebook_auth_desktop {

// Hosts a WebView2 control inside a modal Win32 window.
//
// This is the Windows counterpart of the `WebViewController` used by the macOS
// implementation: it loads the Facebook OAuth dialog and watches every
// navigation until one of them points at the redirect URL, which carries the
// access token in its fragment.
class WebViewHost {
 public:
  // Invoked once with the intercepted callback URL, or with std::nullopt when
  // the user dismissed the window before finishing the flow.
  using CompletionHandler = std::function<void(std::optional<std::string>)>;

  // Invoked instead of CompletionHandler when the WebView2 runtime could not
  // be started at all.
  using ErrorHandler =
      std::function<void(const std::string& code, const std::string& message)>;

  WebViewHost();
  ~WebViewHost();

  WebViewHost(const WebViewHost&) = delete;
  WebViewHost& operator=(const WebViewHost&) = delete;

  // Creates the window and starts loading |url|. Any navigation whose URL
  // contains |target_uri_fragment| completes the flow. Exactly one of
  // |on_complete| / |on_error| is invoked.
  void Show(HWND owner,
            const std::string& url,
            const std::string& target_uri_fragment,
            CompletionHandler on_complete,
            ErrorHandler on_error);

  // True while the window is still on screen.
  bool is_open() const { return window_ != nullptr; }

 private:
  static LRESULT CALLBACK WndProc(HWND window,
                                  UINT message,
                                  WPARAM wparam,
                                  LPARAM lparam) noexcept;

  // Registers the window class the first time it is needed.
  static const wchar_t* WindowClass();

  LRESULT HandleMessage(HWND window,
                        UINT message,
                        WPARAM wparam,
                        LPARAM lparam) noexcept;

  // Kicks off the asynchronous WebView2 environment/controller creation.
  void CreateWebView();

  // Wires up the navigation listeners and starts loading `pending_url_`.
  HRESULT OnControllerCreated(ICoreWebView2Controller* controller);

  // Cancels the navigation and reports |url| when it matches the redirect.
  bool InterceptNavigation(const std::wstring& url);

  // Delivers the result exactly once; further calls are ignored.
  void Complete(std::optional<std::string> callback_url);
  void Fail(const std::string& code, const std::string& message);

  void ResizeWebView();
  void CloseWindow();

  HWND window_ = nullptr;
  HWND owner_ = nullptr;
  bool owner_was_enabled_ = false;

  Microsoft::WRL::ComPtr<ICoreWebView2Controller> controller_;
  Microsoft::WRL::ComPtr<ICoreWebView2> webview_;

  std::wstring pending_url_;
  std::wstring target_uri_fragment_;

  CompletionHandler on_complete_;
  ErrorHandler on_error_;
  bool responded_ = false;

  // Guards the asynchronous WebView2 callbacks against a destroyed host: the
  // destructor flips this to false and every callback bails out early.
  std::shared_ptr<bool> alive_ = std::make_shared<bool>(true);
};

}  // namespace facebook_auth_desktop

#endif  // FLUTTER_PLUGIN_FACEBOOK_AUTH_DESKTOP_WEBVIEW_HOST_H_
