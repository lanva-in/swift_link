// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_write_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BleWriteState _$BleWriteStateFromJson(Map<String, dynamic> json) =>
    BleWriteState(
      state: json['state'] as bool,
      uuid: json['uuid'] as String,
      macAddress: json['macAddress'] as String,
      type: $enumDecode(_$BluetoothWriteTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$BleWriteStateToJson(BleWriteState instance) =>
    <String, dynamic>{
      'state': instance.state,
      'uuid': instance.uuid,
      'macAddress': instance.macAddress,
      'type': _$BluetoothWriteTypeEnumMap[instance.type]!,
    };

const _$BluetoothWriteTypeEnumMap = {
  BluetoothWriteType.withResponse: 'withResponse',
  BluetoothWriteType.withoutResponse: 'withoutResponse',
  BluetoothWriteType.error: 'error',
};
