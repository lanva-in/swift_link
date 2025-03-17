import 'dart:typed_data';

import 'package:bluetooth/pigeon_generate/bluetooth_api.g.dart';
import 'package:json_annotation/json_annotation.dart';

part 'write_message.g.dart';

@JsonSerializable()
class WriteMessage {
  /// 写入数据
  List<int> data;

  /// 设备uuid
  String uuid;

  /// 设备mac地址
  String macAddress;

  /// 命令类型 0 基础命令，1 健康数据
  int command;

  /// 写入类型 0 带响应的写入，1 无响应的写入
  int writeType;

  /// 协议平台 0 爱都, 1 恒玄, 2 VC
  int protocolPlatform;

  WriteMessage({
    required this.data,
    required this.uuid,
    required this.macAddress,
    required this.command,
    required this.writeType,
    required this.protocolPlatform,
  });

  factory WriteMessage.fromJson(Map<String, dynamic> json) => _$WriteMessageFromJson(json);

  Map<String, dynamic> toJson() => _$WriteMessageToJson(this);

  ApiWriteMessage toApiWriteMessage() {
    return ApiWriteMessage(
      data: Uint8List.fromList(data),
      uuid: uuid,
      macAddress: macAddress,
      command: command,
      writeType: writeType,
      protocolPlatform: protocolPlatform,
    );
  }

}