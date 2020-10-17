//
//  BluetoothManager.swift
//  Trable
//
//  Created by nc on 06.10.20.
//

import CoreBluetooth

class BluetoothManager {
    public static var shared = BluetoothManager()
    private init() { }
    
    private var peripheralManager: CBPeripheralManager?

    public func initializeBluetoothManager(withDelegate delegate: CBPeripheralManagerDelegate) {
        peripheralManager = CBPeripheralManager()
        peripheralManager?.delegate = delegate
    }
    
    public func startAdvertising() {
        peripheralManager?.startAdvertising([CBAdvertisementDataLocalNameKey: "TRBLE-\(TrableServerManager.shared.bleAdvertisementId)"])
    }
    
    public func stopAdvertising() {
        peripheralManager?.stopAdvertising()
    }
}
