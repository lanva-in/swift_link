#include "include/bluetooth/bluetooth_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "bluetooth_plugin.h"

void BluetoothPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  bluetooth::BluetoothPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
