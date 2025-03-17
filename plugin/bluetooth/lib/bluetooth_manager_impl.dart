part of 'bluetooth_manager.dart';

class BluetoothManagerImpl
    with BluetoothTimerMixin, BluetoothStateMixin
    implements BluetoothManager {
  final _bluetooth = ApiBluetooth();

  final _listener = BluetoothListener();

  late final _allScanResult = <String, BleDeviceInfo>{};

  late final _allConnectedDevices = <String, BleDeviceInfo>{};

  late final _needReconnectDevices = <String, BleDeviceInfo>{};

  late final _streamListDevice =
      StreamController<List<BleDeviceInfo>>.broadcast();

  Timer? _scanTimer;

  /// 是否需要连接
  bool _isNeedConnect = false;

  /// 绑定状态，外部同步过来,如果标记为绑定状态会启用重连设备流程
  bool _isAutoConnect = false;

  /// 当前连接的设备
  BleDeviceInfo? _currentDevice;

  //单例
  static final BluetoothManagerImpl _instance =
      BluetoothManagerImpl._internal();

  factory BluetoothManagerImpl() => _instance;

  BluetoothManagerImpl._internal() {
    ApiBluetoothListener.setup(_listener);
    init();
  }

  init() {
    _listener.streamScanDevice.stream.listen((event) {
      _allScanResult[event.uuid] = event;
      _streamListDevice.add(_allScanResult.values.toList());
      if (_isNeedConnect) {
        if (_isAutoConnect) {
          if (_needReconnectDevices.keys.contains(event.uuid) &&
              !_allConnectedDevices.keys.contains(event.uuid)) {
            final apiDevice = event.toApiBleDevice();
            _bluetooth.connect(apiDevice);
            var device = _allScanResult[event.uuid];
            if (device != null) {
              device.state = BluetoothDeviceStateType.connecting;
              device.errorState = BluetoothDeviceConnectErrorType.none;
              _allConnectedDevices[event.uuid] = device;
            }
            if (_needReconnectDevices.keys.length ==
                _allConnectedDevices.keys.length) {
              stopBleScan();
            }
          }
        } else {
          if (_currentDevice?.uuid == event.uuid) {
            writeLog('BluetoothManagerImpl', 'streamScanDevice',
                'listen scan success find device');
            _isNeedConnect = false;
            connectDevice(event);
            stopBleScan();
          }
        }
      }
    });

    _listener.streamDeviceState.stream.listen((event) async {
      if (event.state == BluetoothDeviceStateType.connected ||
          event.state == BluetoothDeviceStateType.disconnected) {
        _currentDevice = null;
        cancelAllTimer();
      }
      if (event.state == BluetoothDeviceStateType.disconnected) {
        writeLog('BluetoothManagerImpl', 'streamDeviceState',
            'listen scan disconnect device == ${event.uuid}');
        /// 断开连接后移除
        _allConnectedDevices.remove(event.uuid);
        _autoReconnect();
      }
      if (event.state == BluetoothDeviceStateType.connected ||
          event.state == BluetoothDeviceStateType.connecting) {
        /// 连接中或连接成功后添加
        var device = _allConnectedDevices[event.uuid];
        if (device != null) {
          device.state = event.state;
          device.errorState = BluetoothDeviceConnectErrorType.none;
          _allConnectedDevices[event.uuid] = device;
        }else {
          device = _allScanResult[event.uuid];
          if (device != null) {
             device.state = event.state;
             device.errorState = BluetoothDeviceConnectErrorType.none;
             _allConnectedDevices[event.uuid] = device;
          }
        }
        await stopBleScan();
      }
    });
  }

  /// 断线时重新发起自动重连
  void _autoReconnect() async {
    await stopBleScan();
    final reconnectState = await _getNeedReconnectDevicesState();
    final poweredOnState = await poweredOn;
    writeLog(
        'BluetoothManagerImpl',
        '_autoReconnect',
        'isAutoConnect:$_isAutoConnect '
        'needReconnectDevices.isEmpty:${_needReconnectDevices.isEmpty} '
        'reconnectState: $reconnectState '
        'poweredOnState:$poweredOnState');
    if (_isAutoConnect == false ||
        _needReconnectDevices.isEmpty ||
        reconnectState == false ||
        poweredOnState == false) {
      return;
    }
    cancelAllTimer();
    _isNeedConnect = true;
    await _addScanInterval();
  }

  _addScanInterval() async {
    final bleState = await getBleState();
    final scanning = bleState.scanType == BluetoothScanType.scanning;
    final stop = bleState.scanType == BluetoothScanType.stop;
    addScanIntervalTimeOut(() async{
      if (scanning) {
        writeLog(
            'BluetoothManagerImpl', '_addScanInterval', 'stop scan interval');
        await stopBleScan();
      } else if (stop) {
        writeLog(
            'BluetoothManagerImpl', '_addScanInterval', 'start scan interval');
        await startBleScan();
      }
      _addScanInterval();
    },duration: scanning ? 30 : 2);

    if(!scanning && !stop) {
      writeLog('BluetoothManagerImpl', '_addScanInterval', 'cancel all timer');
      cancelAllTimer();
    }
  }

  BleDeviceInfo? getLastConnectedDevice() {
    if (_allConnectedDevices.isEmpty) {
      return null;
    }
    return _allConnectedDevices.values.last;
  }

  @override
  Map<String, BleDeviceInfo> get allConnectedDevices => _allConnectedDevices;

  @override
  BleDeviceInfo? get lastConnectedDevice => getLastConnectedDevice();

  @override
  Future<bool> autoConnect(List<BleDeviceInfo> devices) async {
    _isNeedConnect = false;
    _isAutoConnect = false;

    _needReconnectDevices.clear();
    for (var element in devices) {
      _needReconnectDevices[element.uuid] = element;
    }

    if (devices.isEmpty) {
      return false;
    }

    /// 取消其他的连接设备
    final cancelDevices = _getNeedCancelDisconnectDevice();
    for (var element in cancelDevices) {
      await cancelDeviceConnect(device: element);
    }

    _isNeedConnect = true;
    _isAutoConnect = true;

    if (await _getNeedReconnectDevicesState() == false) {
      return false;
    }

    _isNeedConnect = true;
    _isAutoConnect = true;
    return startBleScan();
  }

  @override
  Stream<BleStateModel> bluetoothState() {
    return _listener.streamBleState.stream;
  }

  @override
  Stream<BleDeviceStateModel> deviceState() {
    return _listener.streamDeviceState.stream;
  }

  @override
  Stream<BleReceiveData> receiveBleData() {
    return _listener.streamBleReceive.stream;
  }

  @override
  Stream<List<BleDeviceInfo>> scanResult() {
    return _streamListDevice.stream.map((event) {
      final filter = event
          .where((element) =>
              (element.rssi.abs() <= 100 && element.rssi.abs() >= 0))
          .toList();
      filter.sort((a, b) => a.rssi.abs().compareTo(b.rssi.abs()));
      return filter;
    });
  }

  @override
  Stream<BleWriteState> writeDataState({BleDeviceInfo? device}) {
    return _listener.streamWriteState.stream;
  }

  @override
  Future<bool> connectDevice(BleDeviceInfo? device, {int timeout = 30}) async {
    if (device == null) {
      writeLog('BluetoothManagerImpl', 'connectDevice', 'device is null');
      return Future(() => false);
    }
    final currentState = await getCurrentDeviceState(device);
    if (currentState.state == BluetoothDeviceStateType.connected &&
        currentState.errorState == BluetoothDeviceConnectErrorType.none) {
      writeLog('BluetoothManagerImpl', 'connectDevice',
          'device is connected, return true');
      _listener.streamDeviceState.add(BleDeviceStateModel(
          uuid: device.uuid,
          macAddress: device.macAddress,
          state: BluetoothDeviceStateType.connected,
          errorState: BluetoothDeviceConnectErrorType.none,
          protocolPlatform: 0));
      return Future(() => true);
    }
    cancelAllTimer();
    addConnectTimeout(() {
      _timeoutHandler();
    }, duration: timeout);

    _isAutoConnect = false;

    writeLog('BluetoothManagerImpl', 'connectDevice',
        '_isAutoConnect === false');

    final lastDevice = _currentDevice;
    final cancelDevices = _needReconnectDevices.values.toList();
    if (lastDevice != null) {
      cancelDevices.add(lastDevice);
    }

    for (var element in cancelDevices) {
      /// 先断开缓存当前连接的设备
      final state = await getCurrentDeviceState(element);
      if (element.uuid != device.uuid &&
          (state.state == BluetoothDeviceStateType.connected ||
              state.state == BluetoothDeviceStateType.connecting)) {
        writeLog('BluetoothManagerImpl', 'connectDevice',
            'cancel connect first device');
        await cancelDeviceConnect(device: element);
        await deviceState()
            .map((event) =>
                event.state == BluetoothDeviceStateType.disconnected &&
                event.uuid == element.uuid)
            .first
            .timeout(const Duration(seconds: 5), onTimeout: () {
          writeLog('BluetoothManagerImpl', 'connectDevice',
              'cancel connect first device timeout');
          return true;
        });
      }
    }

    _currentDevice = device.copyWith();
    final findDevice = _allScanResult[device.uuid];
    if (findDevice != null) {
      writeLog('BluetoothManagerImpl', 'connectDevice',
          'find device in scan result');
      _isNeedConnect = false;
      final apiDevice = findDevice.toApiBleDevice();
      await _bluetooth.connect(apiDevice);
      return stopBleScan();
    } else {
      writeLog(
          'BluetoothManagerImpl', 'connectDevice', 'device not in scan result');
      _isNeedConnect = true;
      return startBleScan();
    }
  }

  @override
  Future<BleStateModel> getBleState() async {
    final state = await _bluetooth.getBluetoothState();
    final bleState = BleStateModel.fromApiBleSateModel(state);
    return bleState;
  }

  @override
  Future<BleDeviceStateModel> getCurrentDeviceState(
      BleDeviceInfo? device) async {
    if (device == null) {
      return Future(() => BleDeviceStateModel(
          uuid: 'unknown',
          macAddress: 'unknown',
          state: BluetoothDeviceStateType.disconnected,
          errorState: BluetoothDeviceConnectErrorType.none,
          protocolPlatform: 0));
    }
    final apiDevice = device.toApiBleDevice();
    final deviceState = await _bluetooth.getDeviceState(apiDevice);
    final state = BleDeviceStateModel.fromApiDeviceState(deviceState);
    return state;
  }

  static int rescanCount = 0;

  @override
  Future<bool> startBleScan({int seconds = 0}) async {
    final model = await getBleState();
    if (await poweredOn) {
      if (seconds > 0) {
        _scanTimer?.cancel();
        _scanTimer = Timer.periodic(Duration(seconds: seconds), (timer) {
          _bluetooth.stopScan().then((value) => timer.cancel());
        });
      }
      _allScanResult.clear();
      rescanCount = 0;
      writeLog('BluetoothManagerImpl', 'startBleScan', 'start scan');
      return _bluetooth.startScan();
    } else if (!await authorized || model.state == BluetoothStateType.unknown) {
      if (rescanCount > 3) {
        return false;
      }
      writeLog(
          'BluetoothManagerImpl', 'startBleScan', 'start scan unauthorized');
      return Future.delayed(const Duration(seconds: 1), () {
        rescanCount++;
        return startBleScan();
      });
    } else {
      rescanCount = 0;
      writeLog('BluetoothManagerImpl', 'startBleScan',
          'startScan waiting,BluetoothState = ${model.state}');
      return Future(() => false);
    }
  }

  @override
  Future<bool> stopBleScan() {
    writeLog('BluetoothManagerImpl', 'stopBleScan', '');
    _scanTimer?.cancel();
    _scanTimer = null;
    return _bluetooth.stopScan();
  }

  @override
  Future<BleWriteState> writeBleData(WriteMessage message,
      {BleDeviceInfo? device}) async {
    if (device == null) {
      return BleWriteState(
          state: false,
          uuid: device?.uuid ?? 'unknown',
          macAddress: device?.macAddress ?? 'unknown',
          type: BluetoothWriteType.error);
    }
    final apiDevice = device.toApiBleDevice();
    final apiMessage = message.toApiWriteMessage();
    final state = await _bluetooth.writeData(apiMessage, apiDevice, 0);
    final writeState = BleWriteState.fromApiWriteState(state);
    return writeState;
  }

  @override
  Stream<Map> bleLog() {
    return _listener.streamBleLog.stream;
  }

  @override
  Future<bool> cancelDeviceConnect({BleDeviceInfo? device}) async {
    if (device == null) {
      _listener.streamDeviceState.add(BleDeviceStateModel(
          uuid: 'unknown',
          macAddress: 'unknown',
          state: BluetoothDeviceStateType.disconnected,
          errorState: BluetoothDeviceConnectErrorType.none,
          protocolPlatform: 0));
      return true;
    } else {
      cancelAllTimer();
      final model = await _bluetooth.getBluetoothState();
      if (model.state == ApiBluetoothStateType.poweredOff) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          _listener.streamDeviceState.add(BleDeviceStateModel(
              uuid: device.uuid,
              macAddress: device.macAddress,
              state: BluetoothDeviceStateType.disconnected,
              errorState: BluetoothDeviceConnectErrorType.cancelByUser,
              protocolPlatform: 0));
        });
        return true;
      }
      final apiDevice = device.toApiBleDevice();
      await _bluetooth.cancelConnect(apiDevice);
      return deviceState()
          .map((event) =>
              event.state == BluetoothDeviceStateType.disconnected &&
              event.errorState == BluetoothDeviceConnectErrorType.connectCancel)
          .first
          .timeout(const Duration(seconds: 5), onTimeout: () => true);
    }
  }

  @override
  Future<bool> cancelAllDevicesConnect() async {
    final devices = allConnectedDevices.values.toList();
    for (var value in devices) {
      await ble.cancelDeviceConnect(device: value);
    }
    await autoConnect([]);
    return true;
  }

  /// 写日志
  void writeLog(String className, String method, String detail) {
    _listener.onWriteLog({
      'platform': 3, //'platform': 1：ios、2：android、3：flutter、macos：4
      'className': className,
      'method': method,
      'detail': detail
    });
  }

  /// 连接超时处理
  void _timeoutHandler() async {
    writeLog('BluetoothManagerImpl', 'connectDevice',
        'connect timeout == ${_currentDevice?.uuid}');
    final state = await getCurrentDeviceState(_currentDevice);
    if (state.state == BluetoothDeviceStateType.disconnected) {
      _listener.streamDeviceState.add(BleDeviceStateModel(
          uuid: _currentDevice?.uuid ?? 'unknown',
          macAddress: _currentDevice?.macAddress ?? 'unknown',
          state: BluetoothDeviceStateType.disconnected,
          errorState: BluetoothDeviceConnectErrorType.timeOut,
          protocolPlatform: 0));
    } else {
      cancelDeviceConnect(device: _currentDevice);
    }
  }

  /// 获取需要取消连接的设备
  List<BleDeviceInfo> _getNeedCancelDisconnectDevice() {
    if (_needReconnectDevices.isNotEmpty && _allConnectedDevices.isNotEmpty) {
      final otherDevices = _allConnectedDevices.values
          .where((element1) => _needReconnectDevices.values
              .any((element2) => element2.uuid != element1.uuid))
          .toList();
      return otherDevices;
    } else if (_needReconnectDevices.isEmpty &&
        _allConnectedDevices.isNotEmpty) {
      return _allConnectedDevices.values.toList();
    } else {
      return [];
    }
  }

  /// 判断是否需要重连设备
  Future<bool> _getNeedReconnectDevicesState() async {
    var isNeedReconnect = false;
    for (var value in _needReconnectDevices.values) {
      final state = await getCurrentDeviceState(value);
      if (state.state != BluetoothDeviceStateType.connected) {
        isNeedReconnect = true;
        break;
      }
    }
    return isNeedReconnect;
  }
}

class BluetoothListener extends ApiBluetoothListener {
  late final streamBleState = StreamController<BleStateModel>.broadcast();
  late final streamDeviceState =
      StreamController<BleDeviceStateModel>.broadcast();
  late final streamBleReceive = StreamController<BleReceiveData>.broadcast();
  late final streamScanDevice = StreamController<BleDeviceInfo>.broadcast();
  late final streamBleLog = StreamController<Map>.broadcast();
  late final streamWriteState = StreamController<BleWriteState>.broadcast();

  @override
  void onBluetoothState(ApiBleStateModel data) {
    final state = BluetoothStateType.values[data.state?.index ?? 0];
    final scanType = BluetoothScanType.values[data.scanType?.index ?? 0];
    final model = BleStateModel(state: state, scanType: scanType);
    streamBleState.add(model);
  }

  @override
  void onDeviceState(ApiBleDeviceStateModel data) {
    final state = BluetoothDeviceStateType.values[data.state?.index ?? 0];
    final errorState =
        BluetoothDeviceConnectErrorType.values[data.errorState?.index ?? 0];
    final uuid = data.uuid ?? 'unknown';
    final macAddress = data.macAddress ?? 'unknown';
    final protocolPlatform = data.protocolPlatform ?? 0;
    final model = BleDeviceStateModel(
        uuid: uuid,
        macAddress: macAddress,
        state: state,
        errorState: errorState,
        protocolPlatform: protocolPlatform);
    streamDeviceState.add(model);
  }

  @override
  void onDiscoverCharacteristics(List<String?> uuids) {}

  @override
  void onReceiveData(ApiBleReceiveData data) {
    final uuid = data.uuid ?? 'unknown';
    final macAddress = data.macAddress ?? 'unknown';
    final protocolPlatform = data.protocolPlatform ?? 0;
    final rs = data.data?.toList() ?? [];
    final model = BleReceiveData(
        data: rs,
        uuid: uuid,
        macAddress: macAddress,
        spp: false,
        protocolPlatform: protocolPlatform);
    streamBleReceive.add(model);
  }

  @override
  void onScanResult(ApiBleDevice data) {
    final model = BleDeviceInfo.fromApiBleDevice(data);
    streamScanDevice.add(model);
  }

  @override
  void onWriteLog(Map<Object?, Object?> data) {
    streamBleLog.add(data);
  }

  @override
  void onWriteState(ApiBleWriteState data) {
    final type = BluetoothWriteType.values[data.type?.index ?? 0];
    final uuid = data.uuid ?? 'unknown';
    final macAddress = data.macAddress ?? 'unknown';
    final writeSate = data.state ?? false;
    final model = BleWriteState(
        type: type, uuid: uuid, macAddress: macAddress, state: writeSate);
    streamWriteState.add(model);
  }
}
