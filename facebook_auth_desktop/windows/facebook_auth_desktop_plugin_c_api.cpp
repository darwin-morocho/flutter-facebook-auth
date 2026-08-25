#include "include/facebook_auth_desktop/facebook_auth_desktop_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "facebook_auth_desktop_plugin.h"

void FacebookAuthDesktopPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  facebook_auth_desktop::FacebookAuthDesktopPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
