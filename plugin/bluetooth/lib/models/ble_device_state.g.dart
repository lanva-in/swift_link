// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_device_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BleDeviceStateModel _$BleDeviceStateModelFromJson(Map<String, dynamic> json) =>
    BleDeviceStateModel(
      uuid: json['uuid'] as String,
      macAddress: json['macAddress'] as String,
      state: $enumDecode(_$BluetoothDeviceStateTypeEnumMap, json['state']),
      errorState: $enumDecode(
          _$BluetoothDeviceConnectErrorTypeEnumMap, json['errorState']),
      protocolPlatform: (json['protocolPlatform'] as num).toInt(),
    );

Map<String, dynamic> _$BleDeviceStateModelToJson(
        BleDeviceStateModel instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'macAddress': instance.macAddress,
      'state': _$BluetoothDeviceStateTypeEnumMap[instance.state]!,
      'errorState':
          _$BluetoothDeviceConnectErrorTypeEnumMap[instance.errorState]!,
      'protocolPlatform': instance.protocolPlatform,
    };

const _$BluetoothDeviceStateTypeEnumMap = {
  BluetoothDeviceStateType.disconnected: 'disconnected',
  BluetoothDeviceStateType.connecting: 'connecting',
  BluetoothDeviceStateType.connected: 'connected',
  BluetoothDeviceStateType.disconnecting: 'disconnecting',
};

const _$BluetoothDeviceConnectErrorTypeEnumMap = {
  BluetoothDeviceConnectErrorType.none: 'none',
  BluetoothDeviceConnectErrorType.abnormalUUIDMacAddress:
      'abnormalUUIDMacAddress',
  BluetoothDeviceConnectErrorType.bluetoothOff: 'bluetoothOff',
  BluetoothDeviceConnectErrorType.connectCancel: 'connectCancel',
  BluetoothDeviceConnectErrorType.fail: 'fail',
  BluetoothDeviceConnectErrorType.timeOut: 'timeOut',
  BluetoothDeviceConnectErrorType.serviceFail: 'serviceFail',
  BluetoothDeviceConnectErrorType.characteristicsFail: 'characteristicsFail',
  BluetoothDeviceConnectErrorType.pairFail: 'pairFail',
  BluetoothDeviceConnectErrorType.informationFail: 'informationFail',
  BluetoothDeviceConnectErrorType.cancelByUser: 'cancelByUser',
};
