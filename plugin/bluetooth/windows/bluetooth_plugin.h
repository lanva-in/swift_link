#ifndef FLUTTER_PLUGIN_BLUETOOTH_PLUGIN_H_
#define FLUTTER_PLUGIN_BLUETOOTH_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace bluetooth {

class BluetoothPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  BluetoothPlugin();

  virtual ~BluetoothPlugin();

  // Disallow copy and assign.
  BluetoothPlugin(const BluetoothPlugin&) = delete;
  BluetoothPlugin& operator=(const BluetoothPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace bluetooth

#endif  // FLUTTER_PLUGIN_BLUETOOTH_PLUGIN_H_
