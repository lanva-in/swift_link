import 'package:bluetooth/bluetooth.dart';

mixin BluetoothStateMixin {

  /// 是否授权
  Future<bool> get authorized async {
    final model = await ble.getBleState();
    return !(model.state == BluetoothStateType.unknown ||
        model.state == BluetoothStateType.unauthorized ||
        model.state == BluetoothStateType.unsupported);
  }

  /// 蓝牙是否开打
  Future<bool> get poweredOn async {
    final model = await ble.getBleState();
    return model.state == BluetoothStateType.poweredOn;
  }

  /// 蓝牙是否关闭
  Future<bool> get poweredOff async {
    final model = await ble.getBleState();
    return model.state == BluetoothStateType.poweredOff;
  }

}