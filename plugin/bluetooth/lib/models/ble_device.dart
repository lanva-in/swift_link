import 'dart:io';
import 'dart:typed_data';

import 'ble_enum.dart';
import 'package:bluetooth/pigeon_generate/bluetooth_api.g.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ble_device.g.dart';

@JsonSerializable()
class BleDeviceInfo {
  /// 设备名称
  String name;

  /// 设备mac地址
  String macAddress;

  /// 设备uuid
  String uuid;

  /// 设备状态
  BluetoothDeviceStateType state;

  /// 连接错误状态
  BluetoothDeviceConnectErrorType errorState;

  /// 设备广播包数据
  List<int> dataManufacturerData;

  /// 设备信号强度
  int rssi;

  /// 协议平台 0 爱都, 1 恒玄, 2 VC
  int protocolPlatform;

  /// 设备ID
  int deviceId;

  /// 设备类型
  int deviceType;

  BleDeviceInfo({
    required this.name,
    required this.macAddress,
    required this.uuid,
    required this.state,
    required this.errorState,
    required this.dataManufacturerData,
    required this.rssi,
    required this.protocolPlatform,
    required this.deviceId,
    required this.deviceType,
  });

  factory BleDeviceInfo.fromJson(Map<String, dynamic> json) => _$BleDeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BleDeviceInfoToJson(this);

  BleDeviceInfo copyWith() {
    return BleDeviceInfo(
      name: name,
      macAddress: macAddress,
      uuid: uuid,
      state: state,
      errorState: errorState,
      dataManufacturerData: dataManufacturerData,
      rssi: rssi,
      protocolPlatform: protocolPlatform,
      deviceId: deviceId,
      deviceType: deviceType,
    );
  }

  ApiBleDevice toApiBleDevice() {
    return ApiBleDevice(
      name: name,
      macAddress: macAddress,
      uuid: uuid,
      state: ApiBluetoothDeviceStateType.values[state.index],
      errorState: ApiBluetoothDeviceConnectErrorType.values[errorState.index],
      dataManufacturerData: Uint8List.fromList(dataManufacturerData),
      rssi: rssi
    );
  }

  static BleDeviceInfo fromApiBleDevice(ApiBleDevice apiBleDevice) {
    final name = apiBleDevice.name ?? 'unknown';
    var macAddress = apiBleDevice.macAddress ?? 'unknown';
    final uuid = apiBleDevice.uuid ?? 'unknown';
    final state = BluetoothDeviceStateType.values[apiBleDevice.state?.index ?? 0];
    final errorState = BluetoothDeviceConnectErrorType.values[apiBleDevice.errorState
        ?.index ?? 0];
    final rssi = apiBleDevice.rssi ?? 0;
    final dataManufacturerData = apiBleDevice.dataManufacturerData?.toList() ?? [];
    final data = dataManufacturerData;
    if (!macAddress.contains(":")) {
      macAddress = _transformADData(Uint8List.fromList(data));
    }
    var deviceId = 0;
    var deviceType = 0;
    var bltVersion = 0;
    if (data.isNotEmpty) {
      int length = data.length;
      deviceId = data[0] | (data[1] << 8);
      bltVersion = length > 8 ? data[8] : 0;
      final type = length > 9 ? data[9] : 0;
      deviceType = type > 2 ? 0 : type;
    }
    final model = BleDeviceInfo(name: name,
        macAddress: macAddress,
        uuid: uuid,
        state: state,
        errorState: errorState,
        dataManufacturerData: dataManufacturerData,
        rssi: rssi,
        protocolPlatform: 0,
        deviceId: deviceId,
        deviceType: deviceType
    );
    return model;
  }

  static String _transformADData(Uint8List data) {
    int length = data.length;
    if (length < 8) {
      return 'unknown';
    }
    if (Platform.isAndroid) {
      return 'unknown';
    }
    var macAddress = 'unknown';
    if (length == 8) {
      macAddress = uint8ListToHexStr(data.sublist(2, 8));
    } else {
      final serviceUuid = uint8ListToHexStr(data.sublist(length - 3, length - 1));
      if (serviceUuid == "0AF0") {
        macAddress = uint8ListToHexStr(data.sublist(length - 9, length - 3));
      } else {
        if (length >= 29 || length == 10) {
          macAddress = uint8ListToHexStr(data.sublist(4, 10));
        } else {
          macAddress = uint8ListToHexStr(data.sublist(2, 8));
        }
      }
    }
    macAddress = addColon(macAddress);
    return macAddress;
  }

  static String addColon(String str) {
    if (str.contains(":")) {
      return str;
    }
    List<String> colonStr = [];
    for (int i = 0; i < str.length; i++) {
      colonStr.add(str.substring(i, i + 1));
    }
    return colonStr.reduce((value, element) {
      return value.length % 3 == 2 ? "$value:$element" : "$value$element";
    });
  }

  static String uint8ListToHexStr(Uint8List byteArr) {
    if (byteArr.isEmpty) {
      return "";
    }
    Uint8List result =
    Uint8List(byteArr.length << 1);
    var hexTable = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F'
    ]; //16进制字符表
    for (var i = 0; i < byteArr.length; i++) {
      var bit = byteArr[i]; //取传入的byteArr的每一位
      var index = bit >> 4 & 15; //右移4位,取剩下四位,&15相当于&F,也就是&1111
      var i2 = i << 1; //byteArr的每一位对应结果的两位,所以对于结果的操作位数要乘2
      result[i2] = hexTable[index].codeUnitAt(0); //左边的值取字符表,转为Unicode放进resut数组
      index = bit & 15; //取右边四位,相当于01011010&00001111=1010
      result[i2 + 1] =
          hexTable[index].codeUnitAt(0);
    }
    return String.fromCharCodes(result);
  }
}