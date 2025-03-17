// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'write_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WriteMessage _$WriteMessageFromJson(Map<String, dynamic> json) => WriteMessage(
      data: (json['data'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      uuid: json['uuid'] as String,
      macAddress: json['macAddress'] as String,
      command: (json['command'] as num).toInt(),
      writeType: (json['writeType'] as num).toInt(),
      protocolPlatform: (json['protocolPlatform'] as num).toInt(),
    );

Map<String, dynamic> _$WriteMessageToJson(WriteMessage instance) =>
    <String, dynamic>{
      'data': instance.data,
      'uuid': instance.uuid,
      'macAddress': instance.macAddress,
      'command': instance.command,
      'writeType': instance.writeType,
      'protocolPlatform': instance.protocolPlatform,
    };
