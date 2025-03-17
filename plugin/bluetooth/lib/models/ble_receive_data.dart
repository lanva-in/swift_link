import 'package:json_annotation/json_annotation.dart';

part 'ble_receive_data.g.dart';

@JsonSerializable()
class BleReceiveData {
  /// 接收到的数据
  List<int> data;

  /// 设备uuid
  String uuid;

  /// 设备mac地址
  String macAddress;

  /// 是否是spp
  bool spp;

  /// 协议平台 0 爱都, 1 恒玄, 2 VC
  int protocolPlatform;

  BleReceiveData({
    required this.data,
    required this.uuid,
    required this.macAddress,
    required this.spp,
    required this.protocolPlatform,
  });

  factory BleReceiveData.fromJson(Map<String, dynamic> json) => _$BleReceiveDataFromJson(json);

  Map<String, dynamic> toJson() => _$BleReceiveDataToJson(this);

}