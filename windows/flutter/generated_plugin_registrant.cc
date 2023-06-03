//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <fc_native_image_resize/fc_native_image_resize_plugin_c_api.h>
#include <flutter_media_metadata/flutter_media_metadata_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FcNativeImageResizePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FcNativeImageResizePluginCApi"));
  FlutterMediaMetadataPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterMediaMetadataPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
