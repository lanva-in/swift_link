/*
蓝牙状态：
未知，
系统服务重启中，
不支持，
未授权，
蓝牙关闭，
蓝牙打开
* */
enum BluetoothStateType {
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
enum BluetoothDeviceStateType {
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
enum BluetoothDeviceConnectErrorType {
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
enum BluetoothWriteType {
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
enum BluetoothScanType {
  scanning,
  stop,
  find,
}
