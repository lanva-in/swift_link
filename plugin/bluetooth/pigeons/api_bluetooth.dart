import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class ApiBluetoothListener {
  /// 收到数据
  /// received data
  void onReceiveData(ApiBleReceiveData data);

  /// 设备状态
  /// device state
  void onDeviceState(ApiBleDeviceStateModel data);

  /// 蓝牙状态
  /// Bluetooth status
  void onBluetoothState(ApiBleStateModel data);

  /// 搜索结果
  /// Search results
  void onScanResult(ApiBleDevice data);

  /// 发送数据状态
  /// on write data state
  void onWriteState(ApiBleWriteState data);

  /// 写入日志
  /// 'platform': 1：ios、2：android、3：flutter、macos：4
  /// 'className': '类名',
  /// 'method': '方法名',
  /// 'detail': '日志内容'
  void onWriteLog(Map data);

  /// 发现特征
  /// on discover characteristics
  void onDiscoverCharacteristics(List<String> uuids);
}

@HostApi()
abstract class ApiBluetooth {
  /// 开始搜索
  @async
  bool startScan();

  /// 停止搜索
  @async
  bool stopScan();

  /// 取消连接
  @async
  bool cancelConnect(ApiBleDevice? device);

  /// 手动连接
  /// device: Mac地址必传，iOS要带上uuid，最好使用搜索返回的对象
  @async
  bool connect(ApiBleDevice? device);

  /// 获取蓝牙状态
  @async
  ApiBleStateModel getBluetoothState();

  /// 获取设备连接状态
  @async
  ApiBleDeviceStateModel getDeviceState(ApiBleDevice? device);

  /// 发送数据
  /// WriteMessage:数据
  /// device: 发送数据的设备
  /// type:0 BLE数据, 1 SPP数据
  @async
  ApiBleWriteState writeData(ApiWriteMessage data, ApiBleDevice? device, int type);

  /// 关闭所有蓝牙通知 （固件需要知道已杀死App）
  @async
  bool closeNotifyCharacteristic();
}

class ApiBleWriteState {
  /// 写入状态
  bool? state;

  /// 设备uuid
  String? uuid;

  /// 设备mac地址
  String? macAddress;

  /// 写入类型
  ApiBluetoothWriteType? type;
}

class ApiBleStateModel {
  /// 蓝牙状态
  ApiBluetoothStateType? state;

  /// 蓝牙扫描状态
  ApiBluetoothScanType? scanType;
}

class ApiBleReceiveData {
  /// 接收到的数据
  Uint8List? data;

  /// 设备uuid
  String? uuid;

  /// 设备mac地址
  String? macAddress;

  /// 是否是spp
  bool? spp;

  /// 协议平台 0 爱都, 1 恒玄, 2 VC
  int? protocolPlatform;
}

class ApiBleDeviceStateModel {
  /// 设备uuid
  String? uuid;

  /// 设备mac地址
  String? macAddress;

  /// 设备状态
  ApiBluetoothDeviceStateType? state;

  /// 连接错误状态
  ApiBluetoothDeviceConnectErrorType? errorState;

  /// 协议平台 0 爱都, 1 恒玄, 2 VC
  int? protocolPlatform;
}

class ApiBleDevice {
  /// 设备名称
  String? name;

  /// 设备mac地址
  String? macAddress;

  /// 设备uuid
  String? uuid;

  /// 设备状态
  ApiBluetoothDeviceStateType? state;

  /// 连接错误状态
  ApiBluetoothDeviceConnectErrorType? errorState;

  /// 设备广播包数据
  Uint8List? dataManufacturerData;

  /// 设备信号强度
  int? rssi;
}

class ApiWriteMessage {
  /// 写入数据
  Uint8List? data;

  /// 设备uuid
  String? uuid;

  /// 设备mac地址
  String? macAddress;

  /// 命令类型 0 基础命令，1 健康数据
  int? command;

  /// 写入类型 0 带响应的写入，1 无响应的写入
  int? writeType;

  /// 协议平台 0 爱都, 1 恒玄, 2 VC
  int? protocolPlatform;
}

/*
蓝牙状态：
未知，
系统服务重启中，
不支持，
未授权，
蓝牙关闭，
蓝牙打开
* */
enum ApiBluetoothStateType {
  unknown,
  resetting,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
}

/*
连接状态：
断开连接，
连接中，
已连接，
断开连接中
*/
enum ApiBluetoothDeviceStateType {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

/*
* 连接错误
无状态
UUID或Mac地址异常
蓝牙关闭
主动断开连接（手机或固件发起）
连接失败
连接超时
发现服务失败
发现特征失败
配对异常
获取基本信息失败
app主动断开
* */
enum ApiBluetoothDeviceConnectErrorType {
  none,
  abnormalUUIDMacAddress,
  bluetoothOff,
  connectCancel,
  fail,
  timeOut,
  serviceFail,
  characteristicsFail,
  pairFail,
  informationFail,
  cancelByUser,
}

/*
* 写数据状态
有响应
无响应
错误
* */
enum ApiBluetoothWriteType {
  withResponse,
  withoutResponse,
  error,
}

/*
* 扫描状态
扫描中
扫描结束
找到设备（android）
* */
enum ApiBluetoothScanType {
  scanning,
  stop,
  find,
}
