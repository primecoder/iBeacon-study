//
//  PeripheralManager.swift
//  HelloBeacon
//
//  Created by ace on 6/12/2024.
//

import Foundation
import CoreLocation
import CoreBluetooth

@Observable
class PeripheralManager: NSObject {
    
    let beaconUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    var peripheralManager: CBPeripheralManager!
    var region: CLBeaconRegion!
    
    var state: CBManagerState { peripheralManager.state }
    
    var heartbeat: Int = 0
    
    override init () {
        super.init()
        
        print("PeripheralManager init")
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.heartbeat += 1
        }
    }
    
    func configureBeaconRegion() {
        guard peripheralManager.state == .poweredOn else {
            print("Bluetooth must be enabled.")
            return
        }
        
        
        peripheralManager.stopAdvertising()
        guard let bundleURL = Bundle.main.bundleIdentifier else {
            print("Can't get bundle identifier!")
            return
        }
        
        print("Ready to rock-n-roll. Bundle ID: \(bundleURL)")
        
        let constraint = CLBeaconIdentityConstraint(uuid: beaconUUID, major: 1, minor: 0)
        region = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: bundleURL)
        let peripheralData = region.peripheralData(withMeasuredPower: nil) as? [String: Any]
        peripheralManager.startAdvertising(peripheralData)
    }
}

extension PeripheralManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState: \(peripheral.state.rawValue)")
    }
    
}
