
import 'ble_enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bluetooth/pigeon_generate/bluetooth_api.g.dart';
part 'ble_state_model.g.dart';

@JsonSerializable()
class BleStateModel {
  /// 蓝牙状态
  BluetoothStateType state;

  /// 蓝牙扫描状态
  BluetoothScanType scanType;

  BleStateModel({
    required this.state,
    required this.scanType,
  });

  factory BleStateModel.fromJson(Map<String, dynamic> json) => _$BleStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$BleStateModelToJson(this);

  static BleStateModel fromApiBleSateModel(ApiBleStateModel apiBleState) {
    final state = BluetoothStateType.values[apiBleState.state?.index ?? 0];
    final scanType = BluetoothScanType.values[apiBleState.scanType?.index ?? 0];
    final model = BleStateModel(state: state, scanType: scanType);
    return model;
  }

}