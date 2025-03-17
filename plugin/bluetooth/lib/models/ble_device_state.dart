
import 'ble_enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bluetooth/pigeon_generate/bluetooth_api.g.dart';

part 'ble_device_state.g.dart';

@JsonSerializable()
class BleDeviceStateModel {
  /// 设备uuid
  String uuid;

  /// 设备mac地址
  String macAddress;

  /// 设备状态
  BluetoothDeviceStateType state;

  /// 连接错误状态
  BluetoothDeviceConnectErrorType errorState;

  /// 协议平台 0 爱都, 1 恒玄, 2 VC
  int protocolPlatform;

  BleDeviceStateModel({
    required this.uuid,
    required this.macAddress,
    required this.state,
    required this.errorState,
    required this.protocolPlatform,
  });

  factory BleDeviceStateModel.fromJson(Map<String, dynamic> json) => _$BleDeviceStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$BleDeviceStateModelToJson(this);

  static BleDeviceStateModel fromApiDeviceState(ApiBleDeviceStateModel data) {
    final state = BluetoothDeviceStateType.values[data.state?.index ?? 0];
    final errorState = BluetoothDeviceConnectErrorType.values[data.errorState
        ?.index ?? 0];
    final uuid = data.uuid ?? 'unknown';
    final macAddress = data.macAddress ?? 'unknown';
    final protocolPlatform = data.protocolPlatform ?? 0;
    final model = BleDeviceStateModel(
        uuid: uuid,
        macAddress: macAddress,
        state: state,
        errorState: errorState,
        protocolPlatform: protocolPlatform
    );
    return model;
  }

}