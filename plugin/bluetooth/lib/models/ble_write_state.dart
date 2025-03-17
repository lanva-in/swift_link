
import 'package:bluetooth/pigeon_generate/bluetooth_api.g.dart';

import 'ble_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ble_write_state.g.dart';

@JsonSerializable()
class BleWriteState {
  /// 写入状态
  bool state;

  /// 设备uuid
  String uuid;

  /// 设备mac地址
  String macAddress;

  /// 写入类型
  BluetoothWriteType type;

  BleWriteState({
    required this.state,
    required this.uuid,
    required this.macAddress,
    required this.type,
  });

  factory BleWriteState.fromJson(Map<String, dynamic> json) => _$BleWriteStateFromJson(json);

  Map<String, dynamic> toJson() => _$BleWriteStateToJson(this);

  static BleWriteState fromApiWriteState(ApiBleWriteState writeState) {
    return BleWriteState(
      state: writeState.state ?? false,
      uuid: writeState.uuid ?? 'unknown',
      macAddress: writeState.macAddress ?? 'unknown',
      type: BluetoothWriteType.values[writeState.type?.index ?? 0],
    );
  }

}