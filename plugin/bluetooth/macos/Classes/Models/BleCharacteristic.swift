//
//  BleCharacteristic.swift
//  bluetooth
//
//  Created by hedongyang on 2024/10/25.
//

import Foundation


struct CharacteristicUUID {
    
    var command: String
    
    var health: String
    
    var read: String
    
    var henXuanSend: String
    
    var henXuanNotify: String
    
    var vcSend: String
    
    var vcNotify: String
    
    var notify: [String]
    
    
    init() {
        self.command = "00000af6-0000-1000-8000-00805f9b34fb"
        self.health = "00000af1-0000-1000-8000-00805f9b34fb"
        self.read = "00001534-1212-EFDE-1523-785FEABCD123"
        self.henXuanSend = "00000814-0000-1000-8000-00805f9b34fb"
        self.henXuanNotify = "00000813-0000-1000-8000-00805f9b34fb"
        self.vcSend = "2D420003-6569-6464-6163-6563696F562D"
        self.vcNotify = "2D420002-6569-6464-6163-6563696F562D"
        self.notify = [
            "00000af7-0000-1000-8000-00805f9b34fb",
            "00000af2-0000-1000-8000-00805f9b34fb",
            "00001531-1212-EFDE-1523-785FEABCD123",
            "00000813-0000-1000-8000-00805f9b34fb",
            "2D420002-6569-6464-6163-6563696F562D"
          ]
    }
    
    
}
