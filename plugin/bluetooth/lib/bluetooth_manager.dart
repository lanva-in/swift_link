import 'dart:async';

import 'package:bluetooth/bluetooth_state_mixin.dart';
import 'package:bluetooth/pigeon_generate/bluetooth_api.g.dart';
import 'bluetooth_timer_mixin.dart';
import 'package:bluetooth/bluetooth.dart';

part 'bluetooth_manager_impl.dart';

final ble = BluetoothManager();

abstract class BluetoothManager {
  /// 初始化蓝牙
  factory BluetoothManager() => BluetoothManagerImpl();

  /// 所有链接的设备
  Map<String, BleDeviceInfo> get allConnectedDevices;

  /// 获取最后连接的设备
  BleDeviceInfo? get lastConnectedDevice;

  /// 获取设备连接状态
  Future<BleDeviceStateModel> getCurrentDeviceState(BleDeviceInfo? device);

  /// 获取蓝牙状态
  Future<BleStateModel> getBleState();

  /// 扫描蓝牙设备
  Future<bool> startBleScan({int seconds = 0});

  /// 停止扫描蓝牙设备
  Future<bool> stopBleScan();

  /// 手动连接
  /// device: Mac地址必传，iOS要带上uuid，最好使用搜索返回的对象
  Future<bool> connectDevice(BleDeviceInfo? device, {int timeout = 30});

  /// 重连设备
  Future<bool> autoConnect(List<BleDeviceInfo> devices);

  /// 取消连接
  Future<bool> cancelDeviceConnect({BleDeviceInfo? device});

  /// 取消所有设备连接
  Future<bool> cancelAllDevicesConnect();

  /// 发送数据
  /// message:数据
  /// device: 发送数据的设备
  Future<BleWriteState> writeBleData(WriteMessage message, {BleDeviceInfo? device});

  /// 发送数据状态
  /// Send data status
  Stream<BleWriteState> writeDataState({BleDeviceInfo? device});

  /// 收到数据
  /// received data
  Stream<BleReceiveData> receiveBleData();

  /// 监听蓝牙状态
  /// Monitor Bluetooth status
  Stream<BleStateModel> bluetoothState();

  /// 监听设备状态状态
  Stream<BleDeviceStateModel> deviceState();

  /// 搜索结果
  Stream<List<BleDeviceInfo>> scanResult();

  /// 蓝牙日志
  Stream<Map> bleLog();
}