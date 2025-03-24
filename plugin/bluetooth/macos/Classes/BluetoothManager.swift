//
//  BluetoothManager.swift
//  bluetooth
//
//  Created by hedongyang on 2024/10/25.
//

import Foundation
import FlutterMacOS
import CoreBluetooth

class BluetoothManager: NSObject {
    
    // 服务索引
    var serviceIndex = 0;
    // 扫描到的设备
    var peripheralDic: [String:BluetoothModel] = [:]
    // 特征集合
    let characteristic = CharacteristicUUID.init()
    // 本地保存设备
    let localDevices = LocalScan()
    
    var delegate: ApiBluetoothListener?
    
    let servicesUUID : [CBUUID] = {
        let uuid = CBUUID.init(string: "00000af0-0000-1000-8000-00805f9b34fb")
        return [uuid]
    }()
    
    static let shared = BluetoothManager()
    private override init() {}
    
    lazy var manager: CBCentralManager = {
        let options: [String : Any] = [
            CBCentralManagerOptionShowPowerAlertKey : true,
            CBCentralManagerOptionRestoreIdentifierKey : "BluetoothStrapRestoreIdentifier"
        ]
        let manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main, options: options)
        return manager
    }();
    
    func writeLog(_ detail: String, method: String,className: String?){
        let json: [String : Any] = [
            "platform" : 4, //'platform': 1：ios、2：android、3：flutter、macos：4
            "className" : className ?? "BluetoothManager",
            "method" : method,
            "detail" : detail]
        delegate?.onWriteLog(data: json, completion: {
            
        })
//        print("write log == \(json)")
    }
    
    private func systemScan(_ mac: String?){
        writeLog("getKeychainList  \(String(describing: localDevices.getKeychainList()))", method: "systemScan", className:"BluetoothManager")
        localDevices.findSystemList(mac)?.forEach({
            writeLog("findSystemDevice " + String(describing: $0.name) + $0.identifier.uuidString,method: "systemScan",className:"BluetoothManager")
            let model = BluetoothModel.init(peripheral: $0,
                                            advertisementData: [:],
                                            RSSI: 0)
            peripheralDic[$0.identifier.uuidString] = model
            let device = getBleDevice(device: model)
            delegate?.onScanResult(data: device, completion: { [self] in
                writeLog("scanResult = " + String(describing: device.name) + String(describing: device.macAddress) + String(describing: device.uuid), method: "didDiscover", className: "BluetoothManager");
            })
        })
    }
}

extension BluetoothManager: ApiBluetooth {
    
    func getBluetoothState(completion: @escaping (Result<ApiBleStateModel, any Error>) -> Void) {
        let state = manager.state.rawValue
        let bleState = ApiBluetoothStateType(rawValue: state) ?? .unknown
        let scanState = manager.isScanning ? ApiBluetoothScanType.scanning : ApiBluetoothScanType.stop
        let model = ApiBleStateModel(state: bleState,scanType: scanState)
        completion(Result.success(model))
    }
    
    
    func writeData(data: ApiWriteMessage, device: ApiBleDevice?, type: Int64, completion: @escaping (Result<ApiBleWriteState, any Error>) -> Void) {
        guard let p = getPeripheral(device) else{
            writeLog("writeData no device find", method: "deviceState", className:"BluetoothManager")
            let state = ApiBleWriteState(state: false,uuid: device?.uuid,macAddress: device?.macAddress,type: ApiBluetoothWriteType.error)
            completion(Result.success(state))
            delegate?.onWriteState(data: state, completion: {})
            return
        }
        if data.protocolPlatform == 1 {
            guard let command = p.henXuan else {
                writeLog("null hen xuan command characteristic", method: "write", className:"BluetoothManager")
                let state = ApiBleWriteState(state: false,uuid: device?.uuid,macAddress: device?.macAddress,type: ApiBluetoothWriteType.error)
                completion(Result.success(state))
                delegate?.onWriteState(data: state, completion: {})
                return
            }
            if let value = data.data?.data {
                let writeType = CBCharacteristicWriteType.withoutResponse
                p.blePeripheral.writeValue(value, for: command, type: writeType)
                let state = ApiBleWriteState(state: true,uuid: device?.uuid,macAddress: device?.macAddress,type: ApiBluetoothWriteType.withoutResponse)
                completion(Result.success(state))
                delegate?.onWriteState(data: state, completion: {})
            }
        } else if data.protocolPlatform == 2 {
            guard let command = p.vc else {
                writeLog("null vc command characteristic", method: "write", className:"BluetoothManager")
                let state = ApiBleWriteState(state: false,uuid: device?.uuid,macAddress: device?.macAddress,type: ApiBluetoothWriteType.error)
                completion(Result.success(state))
                delegate?.onWriteState(data: state, completion: {})
                return
            }
            if let value = data.data?.data {
                let writeType =  CBCharacteristicWriteType(rawValue: Int(data.writeType ?? 0)) ?? CBCharacteristicWriteType.withoutResponse
                p.blePeripheral.writeValue(value, for: command, type: writeType)
                let state = ApiBleWriteState(state: writeType == CBCharacteristicWriteType.withoutResponse ? true : false,uuid: device?.uuid,macAddress: device?.macAddress,type: ApiBluetoothWriteType(rawValue: writeType.rawValue))
                completion(Result.success(state))
                delegate?.onWriteState(data: state, completion: {})
            }
        } else {
            guard let command = data.command == 0 ? p.command : p.health else {
                writeLog("null ido command characteristic", method: "write", className:"BluetoothManager")
                let state = ApiBleWriteState(state: false,uuid: device?.uuid,macAddress: device?.macAddress,type: ApiBluetoothWriteType.error)
                completion(Result.success(state))
                delegate?.onWriteState(data: state, completion: {})
                manager.cancelPeripheralConnection(p.blePeripheral)
                return
            }
            if let value = data.data?.data {
//                 writeLog("send ble data == " + String(describing: value), method: "write", className:"BluetoothManager")
                let writeType =  CBCharacteristicWriteType(rawValue: Int(data.writeType ?? 0)) ?? CBCharacteristicWriteType.withoutResponse
                p.blePeripheral.writeValue(value, for: command, type: writeType)
                let state = ApiBleWriteState(state: writeType == CBCharacteristicWriteType.withoutResponse ? true : false,uuid: device?.uuid,macAddress: device?.macAddress,type: ApiBluetoothWriteType(rawValue: writeType.rawValue))
                completion(Result.success(state))
                delegate?.onWriteState(data: state, completion: {})
            }
        }
    }
    
    
    func startScan(completion: @escaping (Result<Bool, any Error>) -> Void) {
        systemScan(nil)
        manager.delegate = self
        if (manager.isScanning) {
            manager.stopScan()
        }
        let option = [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber.init(value: false)]
        manager.scanForPeripherals(withServices: nil, options: option)
        completion(Result.success(true))
    }
    
    func stopScan(completion: @escaping (Result<Bool, any Error>) -> Void) {
        manager.stopScan()
        completion(Result.success(true))
    }
    
    func cancelConnect(device: ApiBleDevice?, completion: @escaping (Result<Bool, any Error>) -> Void) {
        guard let p = getPeripheral(device) else{
            writeLog("cancelConnect no device find", method: "cancelConnect", className:"BluetoothManager")
            completion(Result.success(false))
            return
        }
        manager.cancelPeripheralConnection(p.blePeripheral)
        completion(Result.success(true))
    }
    
    func connect(device: ApiBleDevice?, completion: @escaping (Result<Bool, any Error>) -> Void) {
        guard let p = getPeripheral(device) else{
            writeLog("connect no device find", method: "connect", className:"BluetoothManager")
            completion(Result.success(false))
            return
        }
        writeLog("connect device name = " + String(describing: device?.name) + "macAddress = " + String(describing: device?.uuid), method: "connect", className:"BluetoothManager")
        manager.delegate = self;
        manager.connect(p.blePeripheral, options: nil)
        completion(Result.success(true))
    }
    
    func getDeviceState(device: ApiBleDevice?, completion: @escaping (Result<ApiBleDeviceStateModel, any Error>) -> Void) {
        guard let p = getPeripheral(device) else{
            writeLog("deviceState no device find", method: "deviceState", className:"BluetoothManager")
            let state = ApiBleDeviceStateModel(uuid: device?.uuid,macAddress: device?.macAddress,state: ApiBluetoothDeviceStateType.disconnected,errorState: ApiBluetoothDeviceConnectErrorType.none)
            completion(Result.success(state))
            return
        }
        let type = ApiBluetoothDeviceStateType(rawValue: p.blePeripheral.state.rawValue)
        let state = ApiBleDeviceStateModel(uuid: device?.uuid,macAddress: device?.macAddress,state: type,errorState: ApiBluetoothDeviceConnectErrorType.none)
        return completion(Result.success(state))
    }
    
    func closeNotifyCharacteristic(completion: @escaping (Result<Bool, any Error>) -> Void) {
        peripheralDic.values.forEach { device in
            device.notifyCharacteristics?.forEach({
                writeLog("关闭通知的服务 \($0)", method: "setCloseNotifyCharacteristic", className:"BluetoothManager")
                device.blePeripheral.setNotifyValue(false, for: $0)
            })
        }
    }
    
    func getPeripheral(_ device: ApiBleDevice?) -> BluetoothModel? {
        if peripheralDic.isEmpty {
            writeLog("peripheral list is null", method: "getPeripheral", className:"BluetoothManager")
            return nil;
        }
        if let p = getOnePeripheral(device) {
            return p
        }
        writeLog("not find peripheral == \(String(describing: device?.uuid))", method: "getPeripheral", className:"BluetoothManager")
        return getOnePeripheral(device)
    }
    
    func getOnePeripheral(_ device: ApiBleDevice?) -> BluetoothModel? {
        if let uuid = device?.uuid, let p = peripheralDic[uuid] {
            return p;
        }
        if let macAddress = device?.macAddress, let p = peripheralDic[macAddress] {
            return p;
        }
        return nil
    }
    
}


extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        writeLog("centralManagerDidUpdateState = " + String(central.state.rawValue), method: "centralManagerDidUpdateState", className:"BluetoothManager")
        let stateNum = NSNumber(value: central.state.rawValue)
        let type = ApiBluetoothStateType(rawValue: Int(truncating: stateNum))
        let state = ApiBleStateModel(state: type)
        delegate?.onBluetoothState(data: state, completion: {
            
        });
    }
    
    func centralManager(_ central: CBCentralManager, 
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        guard let _ = peripheral.name else{
            return;
        }
        var device = ApiBleDevice()
        if var model = peripheralDic[peripheral.identifier.uuidString] {
            model.refresh(peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI)
            device = getBleDevice(device: model)
        }else {
            let model = BluetoothModel.init(peripheral: peripheral,
                                            advertisementData: advertisementData,
                                            RSSI: RSSI)
            peripheralDic[peripheral.identifier.uuidString] = model
            device = getBleDevice(device: model)
        }
        delegate?.onScanResult(data: device, completion: { [self] in
            writeLog("scanResult = " + String(describing: device.name) + String(describing: device.macAddress) + String(describing: device.uuid), method: "didDiscover", className: "BluetoothManager");
        })
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        writeLog("didConnect = " + String(describing: peripheral.name) + String(describing: peripheral.identifier.uuidString), method: "didConnect", className: "BluetoothManager");
    }
    
    func centralManager(_ central: CBCentralManager, 
                        didFailToConnect 
                        peripheral: CBPeripheral,
                        error: Error?) {
        var errorType: ApiBluetoothDeviceConnectErrorType = .fail
        if let localizedDescription = error?.localizedDescription{
            writeLog("didFailToConnect - " + peripheral.identifier.uuidString + " - " + localizedDescription, method: "didFailToConnect", className:"BluetoothManager")
        }
        if error?.localizedDescription == "Peer removed pairing information" {
            errorType = .pairFail
        }
        if var device = peripheralDic[peripheral.identifier.uuidString] {
            device.state = ApiBluetoothDeviceStateType.disconnected.rawValue
            device.errorState = errorType.rawValue
            peripheralDic[peripheral.identifier.uuidString] = device
        }
        let state = ApiBleDeviceStateModel(uuid: peripheral.identifier.uuidString,macAddress: "",state: .disconnected,errorState: errorType,protocolPlatform: 0)
        delegate?.onDeviceState(data: state, completion: {
            
        })
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral
                        peripheral: CBPeripheral,
                        error: Error?) {
        writeLog("didDisconnectPeripheral - " + peripheral.identifier.uuidString + " - " + (error?.localizedDescription ?? ""), method: "didDisconnectPeripheral", className:"BluetoothManager")
        if let _ = error{
            if var device = peripheralDic[peripheral.identifier.uuidString] {
                device.state = ApiBluetoothDeviceStateType.disconnected.rawValue
                device.errorState = ApiBluetoothDeviceConnectErrorType.fail.rawValue
                peripheralDic[peripheral.identifier.uuidString] = device
            }
            let state = ApiBleDeviceStateModel(uuid: peripheral.identifier.uuidString,macAddress: "",state: .disconnected,errorState: .fail,protocolPlatform: 0)
            delegate?.onDeviceState(data: state, completion: {
                
            })
        }else{
            if var device = peripheralDic[peripheral.identifier.uuidString] {
                device.state = ApiBluetoothDeviceStateType.disconnected.rawValue
                device.errorState = ApiBluetoothDeviceConnectErrorType.connectCancel.rawValue
                peripheralDic[peripheral.identifier.uuidString] = device
            }
            let state = ApiBleDeviceStateModel(uuid: peripheral.identifier.uuidString,macAddress: "",state: .disconnected,errorState: .connectCancel,protocolPlatform: 0)
            delegate?.onDeviceState(data: state, completion: {
                
            })
        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    func getBleDevice(device: BluetoothModel) -> ApiBleDevice {
        let state = ApiBluetoothDeviceStateType(rawValue: device.state ?? 0)
        let errorState = ApiBluetoothDeviceConnectErrorType(rawValue: device.errorState ?? 0)
        let bleDevice = ApiBleDevice(name: device.name,macAddress: device.macAddress,uuid: device.uuid,state: state,errorState: errorState,dataManufacturerData: FlutterStandardTypedData(bytes: device.dataManufacturerData ?? Data()),rssi: Int64(device.rssi ?? 0))
        return bleDevice
    }
}


extension BluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let e = error {
            writeLog("didDiscoverServices - " + peripheral.identifier.uuidString + " - " + e.localizedDescription, method: "didDiscoverServices", className: nil)
            if var device = peripheralDic[peripheral.identifier.uuidString] {
                device.state = ApiBluetoothDeviceStateType.disconnected.rawValue
                device.errorState = ApiBluetoothDeviceConnectErrorType.serviceFail.rawValue
                peripheralDic[peripheral.identifier.uuidString] = device
            }
            let state = ApiBleDeviceStateModel(uuid: peripheral.identifier.uuidString,macAddress: "",state: .disconnected,errorState: .serviceFail,protocolPlatform: 0)
            delegate?.onDeviceState(data: state, completion: {})
            return
        }else if peripheral.services?.count == 0 {
            writeLog("didDiscoverServices - " + peripheral.identifier.uuidString + "error: services.count = 0", method: "didDiscoverServices", className: nil)
            if var device = peripheralDic[peripheral.identifier.uuidString] {
                device.state = ApiBluetoothDeviceStateType.disconnected.rawValue
                device.errorState = ApiBluetoothDeviceConnectErrorType.serviceFail.rawValue
                peripheralDic[peripheral.identifier.uuidString] = device
            }
            let state = ApiBleDeviceStateModel(uuid: peripheral.identifier.uuidString,macAddress: "",state: .disconnected,errorState: .serviceFail,protocolPlatform: 0)
            delegate?.onDeviceState(data: state, completion: {})
            return
        }
        serviceIndex = 0;
        writeLog("didDiscoverServices", method: "didDiscoverServices", className: nil)
        peripheral.services?.forEach{peripheral.discoverCharacteristics(nil, for: $0)}
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let e = error {
            writeLog("didDiscoverCharacteristicsFor - " + peripheral.identifier.uuidString + " - " + e.localizedDescription, method: "didDiscoverCharacteristicsFor", className: nil)
            if var device = peripheralDic[peripheral.identifier.uuidString] {
                device.state = ApiBluetoothDeviceStateType.disconnected.rawValue
                device.errorState = ApiBluetoothDeviceConnectErrorType.characteristicsFail.rawValue
                peripheralDic[peripheral.identifier.uuidString] = device
            }
            let state = ApiBleDeviceStateModel(uuid: peripheral.identifier.uuidString,macAddress: "",state: .disconnected,errorState: .characteristicsFail,protocolPlatform: 0)
            delegate?.onDeviceState(data: state, completion: {})
            return
        }
        serviceIndex += 1
        
        // 此处才算正在连接设备成功，要不然前面连接成功设备，特征服务未发现无法操作数据
        setCharacteristics(peripheral, service)
        if  let uuids = peripheral.services?.map({$0.uuid.uuidString}){
            delegate?.onDiscoverCharacteristics(uuids: uuids, completion: {})
        }
        if peripheral.services?.count == serviceIndex {
            writeLog("didDiscoverCharacteristicsFor - connectSucceed",
                     method: "didDiscoverCharacteristicsFor", className: nil)
            if var device = peripheralDic[peripheral.identifier.uuidString] {
                device.state = ApiBluetoothDeviceStateType.connected.rawValue
                device.errorState = ApiBluetoothDeviceConnectErrorType.none.rawValue
                peripheralDic[peripheral.identifier.uuidString] = device
            }
            let device = peripheralDic[peripheral.identifier.uuidString]
            let state = ApiBleDeviceStateModel(uuid: peripheral.identifier.uuidString,macAddress: "",state: ApiBluetoothDeviceStateType.connected,errorState: ApiBluetoothDeviceConnectErrorType.none,protocolPlatform: Int64(device?.protocolPlatform ?? 0))
            delegate?.onDeviceState(data: state, completion: {
                
            })
        }
    }
    
    func setCharacteristics(_ p: CBPeripheral, _ c: CBService) {
        var device = peripheralDic[p.identifier.uuidString]
        c.characteristics?.forEach{
            if $0.uuid.isEqual(CBUUID.init(string:characteristic.command)) {
                writeLog("设置IDO命令服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                device?.command = $0
                device?.protocolPlatform = 0
            }else if $0.uuid.isEqual(CBUUID.init(string:characteristic.health)) {
                writeLog("设置IDO健康服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                device?.health = $0
                device?.protocolPlatform = 0
            }else if $0.uuid.isEqual(CBUUID.init(string:characteristic.read)){
                writeLog("设置IDO读取服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                p.readValue(for: $0)
                device?.protocolPlatform = 0
            }else if $0.uuid.isEqual(CBUUID.init(string:characteristic.henXuanSend)) {
                writeLog("设置为恒玄的服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                device?.henXuan = $0
                device?.protocolPlatform = 1
            }else if $0.uuid.isEqual(CBUUID.init(string:characteristic.vcSend)) {
                writeLog("设置为vc的服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
                device?.vc = $0
                device?.protocolPlatform = 2
            }else if checkHadCharacteristic($0.uuid){
                p.setNotifyValue(true, for: $0)
                device?.notifyCharacteristics?.append($0)
                                writeLog("设置为通知的服务 \($0)", method: "setCharacteristics", className:"BluetoothManager")
            }
            peripheralDic[p.identifier.uuidString] = device
        }
    }
    
    func checkHadCharacteristic(_ uuid: CBUUID) -> Bool {
        return (characteristic.notify.map({CBUUID.init(string: $0)}).contains(uuid))
    }
    
    //数据接收
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let e = error {
            writeLog("didUpdateValueFor error - " + peripheral.identifier.uuidString + " - " + e.localizedDescription, method: "didUpdateValueFor", className: nil)
            return
        }
        if characteristic.value == nil || characteristic.value!.isEmpty{
            writeLog("didUpdateValueFor empty data", method: "didUpdateValueFor", className: nil);
            return
        }
        var platform = 0
        if characteristic.uuid.isEqual(CBUUID.init(string:self.characteristic.henXuanNotify)) {
            platform = 1
        }else if characteristic.uuid.isEqual(CBUUID.init(string:self.characteristic.vcNotify)) {
            platform = 2
        }
        let data = FlutterStandardTypedData(bytes: characteristic.value ?? Data())
        let res = ApiBleReceiveData(data: data,uuid: peripheral.identifier.uuidString,macAddress: "",spp: false,protocolPlatform: Int64(platform))
        delegate?.onReceiveData(data: res, completion: {})
    }
    
    func peripheral(_ peripheral: CBPeripheral, 
                    didWriteValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        var isSuccess: Bool = true
        if let e = error {
            isSuccess = false
            writeLog("didWriteValueFor error - " + peripheral.identifier.uuidString + " - " + e.localizedDescription, method: "didWriteValueFor", className: nil);
        }
        let state = ApiBleWriteState(state: isSuccess,
                                  uuid: peripheral.identifier.uuidString,
                                  macAddress: "",
                                  type: .withResponse)
        delegate?.onWriteState(data: state, completion: {})
    }
}
