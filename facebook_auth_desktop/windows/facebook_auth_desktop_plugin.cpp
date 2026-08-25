#include "facebook_auth_desktop_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <memory>
#include <optional>
#include <string>
#include <utility>

namespace facebook_auth_desktop {

namespace {

constexpr char kChannelName[] = "app.meedu/facebook_auth_desktop";
constexpr char kSignInMethod[] = "signIn";
constexpr char kSignInUriArgument[] = "signInUri";
constexpr char kRedirectUriArgument[] = "redirectUri";

// Reads a required string entry out of the method call arguments.
std::optional<std::string> GetStringArgument(
    const flutter::EncodableMap& arguments,
    const char* key) {
  auto it = arguments.find(flutter::EncodableValue(key));
  if (it == arguments.end()) {
    return std::nullopt;
  }
  const auto* value = std::get_if<std::string>(&it->second);
  if (value == nullptr) {
    return std::nullopt;
  }
  return *value;
}

}  // namespace

// static
void FacebookAuthDesktopPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), kChannelName,
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FacebookAuthDesktopPlugin>(registrar);

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

FacebookAuthDesktopPlugin::FacebookAuthDesktopPlugin(
    flutter::PluginRegistrarWindows* registrar)
    : registrar_(registrar) {}

FacebookAuthDesktopPlugin::~FacebookAuthDesktopPlugin() = default;

HWND FacebookAuthDesktopPlugin::HostWindow() const {
  if (registrar_ == nullptr || registrar_->GetView() == nullptr) {
    return nullptr;
  }
  HWND view = registrar_->GetView()->GetNativeWindow();
  return view != nullptr ? ::GetAncestor(view, GA_ROOT) : nullptr;
}

void FacebookAuthDesktopPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare(kSignInMethod) != 0) {
    result->NotImplemented();
    return;
  }

  const auto* arguments =
      std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (arguments == nullptr) {
    result->Error("invalid_arguments", "Expected a map of arguments.");
    return;
  }
  SignIn(*arguments, std::move(result));
}

void FacebookAuthDesktopPlugin::SignIn(
    const flutter::EncodableMap& arguments,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto sign_in_uri = GetStringArgument(arguments, kSignInUriArgument);
  auto redirect_uri = GetStringArgument(arguments, kRedirectUriArgument);
  if (!sign_in_uri.has_value() || !redirect_uri.has_value()) {
    result->Error("invalid_arguments",
                  "Both signInUri and redirectUri are required.");
    return;
  }

  if (webview_host_ && webview_host_->is_open()) {
    result->Error("already_in_progress",
                  "A Facebook login flow is already in progress.");
    return;
  }

  // Replacing the host tears down the previous (already closed) window.
  webview_host_ = std::make_unique<WebViewHost>();

  // The result has to outlive this call: WebView2 reports back asynchronously.
  auto shared_result =
      std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(
          result.release());

  webview_host_->Show(
      HostWindow(), *sign_in_uri, *redirect_uri,
      [shared_result](std::optional<std::string> callback_url) {
        if (callback_url.has_value()) {
          shared_result->Success(flutter::EncodableValue(*callback_url));
        } else {
          // A dismissed window maps to `null`, which the Dart side turns into
          // LoginStatus.cancelled.
          shared_result->Success(flutter::EncodableValue());
        }
      },
      [shared_result](const std::string& code, const std::string& message) {
        shared_result->Error(code, message);
      });
}

}  // namespace facebook_auth_desktop
