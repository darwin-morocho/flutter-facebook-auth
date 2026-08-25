#ifndef FLUTTER_PLUGIN_FACEBOOK_AUTH_DESKTOP_PLUGIN_H_
#define FLUTTER_PLUGIN_FACEBOOK_AUTH_DESKTOP_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>

#include "webview_host.h"

namespace facebook_auth_desktop {

class FacebookAuthDesktopPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  explicit FacebookAuthDesktopPlugin(
      flutter::PluginRegistrarWindows* registrar);
  ~FacebookAuthDesktopPlugin() override;

  FacebookAuthDesktopPlugin(const FacebookAuthDesktopPlugin&) = delete;
  FacebookAuthDesktopPlugin& operator=(const FacebookAuthDesktopPlugin&) =
      delete;

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void SignIn(
      const flutter::EncodableMap& arguments,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // The top-level window of the Flutter app, used as the login dialog's owner.
  HWND HostWindow() const;

  flutter::PluginRegistrarWindows* registrar_;
  std::unique_ptr<WebViewHost> webview_host_;
};

}  // namespace facebook_auth_desktop

#endif  // FLUTTER_PLUGIN_FACEBOOK_AUTH_DESKTOP_PLUGIN_H_
