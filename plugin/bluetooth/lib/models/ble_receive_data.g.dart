// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_receive_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BleReceiveData _$BleReceiveDataFromJson(Map<String, dynamic> json) =>
    BleReceiveData(
      data: (json['data'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      uuid: json['uuid'] as String,
      macAddress: json['macAddress'] as String,
      spp: json['spp'] as bool,
      protocolPlatform: (json['protocolPlatform'] as num).toInt(),
    );

Map<String, dynamic> _$BleReceiveDataToJson(BleReceiveData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'uuid': instance.uuid,
      'macAddress': instance.macAddress,
      'spp': instance.spp,
      'protocolPlatform': instance.protocolPlatform,
    };
