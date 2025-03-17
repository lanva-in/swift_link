//
//  BluetoothModel.swift
//  bluetooth
//
//  Created by hedongyang on 2024/10/25.
//

import Foundation
import CoreBluetooth

struct BluetoothModel {
    
    /// 设备ID
    var uuid: String
    
    /// 外设对象
    var blePeripheral: CBPeripheral
    
    /// 信号值
    var rssi: Int?
    
    /// 设备名称
    var name: String?
    
    /// 状态
    var state: Int?
    
    /// 连接错误状态
    var errorState: Int?
    
    /// mac地址
    var macAddress: String? = ""
    
    /// 服务
    var serviceUUIDs: [String]? = []
    
    /// 广播包
    var dataManufacturerData: Data?
    
    /// 命令特征
    var command: CBCharacteristic?
    
    /// 健康特征
    var health: CBCharacteristic?
    
    /// 恒玄特征
    var henXuan: CBCharacteristic?
    
    /// 高尔夫特征
    var vc: CBCharacteristic?
    
    /// 使能通知集合
    var notifyCharacteristics: [CBCharacteristic]? = []
    
    /// 协议平台 0 爱都, 1 恒玄, 2 VC
    var protocolPlatform = 0;
    
    init(peripheral: CBPeripheral , advertisementData: Dictionary<String, Any> , RSSI: NSNumber) {
        uuid = peripheral.identifier.uuidString
        name = peripheral.name
        state = peripheral.state.rawValue
        errorState = 0
        rssi = abs(RSSI.intValue)
        blePeripheral = peripheral
        protocolPlatform = 0
        notifyCharacteristics = []
        let data = advertisementData["kCBAdvDataManufacturerData"] as? Data
        dataManufacturerData = data
        if let arr = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID] {
            serviceUUIDs = arr.map{$0.uuidString}
        }
    }
    
    mutating func refresh(peripheral: CBPeripheral , advertisementData: Dictionary<String, Any> , RSSI: NSNumber) {
        uuid = peripheral.identifier.uuidString
        name = peripheral.name
        state = peripheral.state.rawValue
        rssi = abs(RSSI.intValue)
        blePeripheral = peripheral
        let data = advertisementData["kCBAdvDataManufacturerData"] as? Data
        dataManufacturerData = data
        if let arr = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID] {
            serviceUUIDs = arr.map{$0.uuidString}
        }
    }
    
}

