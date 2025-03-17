// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BleDeviceInfo _$BleDeviceInfoFromJson(Map<String, dynamic> json) =>
    BleDeviceInfo(
      name: json['name'] as String,
      macAddress: json['macAddress'] as String,
      uuid: json['uuid'] as String,
      state: $enumDecode(_$BluetoothDeviceStateTypeEnumMap, json['state']),
      errorState: $enumDecode(
          _$BluetoothDeviceConnectErrorTypeEnumMap, json['errorState']),
      dataManufacturerData: (json['dataManufacturerData'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      rssi: (json['rssi'] as num).toInt(),
      protocolPlatform: (json['protocolPlatform'] as num).toInt(),
      deviceId: (json['deviceId'] as num).toInt(),
      deviceType: (json['deviceType'] as num).toInt(),
    );

Map<String, dynamic> _$BleDeviceInfoToJson(BleDeviceInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'macAddress': instance.macAddress,
      'uuid': instance.uuid,
      'state': _$BluetoothDeviceStateTypeEnumMap[instance.state]!,
      'errorState':
          _$BluetoothDeviceConnectErrorTypeEnumMap[instance.errorState]!,
      'dataManufacturerData': instance.dataManufacturerData,
      'rssi': instance.rssi,
      'protocolPlatform': instance.protocolPlatform,
      'deviceId': instance.deviceId,
      'deviceType': instance.deviceType,
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
