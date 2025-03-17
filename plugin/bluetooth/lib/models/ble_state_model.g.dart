// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BleStateModel _$BleStateModelFromJson(Map<String, dynamic> json) =>
    BleStateModel(
      state: $enumDecode(_$BluetoothStateTypeEnumMap, json['state']),
      scanType: $enumDecode(_$BluetoothScanTypeEnumMap, json['scanType']),
    );

Map<String, dynamic> _$BleStateModelToJson(BleStateModel instance) =>
    <String, dynamic>{
      'state': _$BluetoothStateTypeEnumMap[instance.state]!,
      'scanType': _$BluetoothScanTypeEnumMap[instance.scanType]!,
    };

const _$BluetoothStateTypeEnumMap = {
  BluetoothStateType.unknown: 'unknown',
  BluetoothStateType.resetting: 'resetting',
  BluetoothStateType.unsupported: 'unsupported',
  BluetoothStateType.unauthorized: 'unauthorized',
  BluetoothStateType.poweredOff: 'poweredOff',
  BluetoothStateType.poweredOn: 'poweredOn',
};

const _$BluetoothScanTypeEnumMap = {
  BluetoothScanType.scanning: 'scanning',
  BluetoothScanType.stop: 'stop',
  BluetoothScanType.find: 'find',
};
