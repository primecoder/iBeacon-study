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
    
//    let beaconUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    let beaconUUID = UUID(uuidString: "8B96586C-2AAB-488F-80BA-7774290D0C8D")!
    var peripheralManager: CBPeripheralManager!
    var region: CLBeaconRegion!
    
    var state: CBManagerState { peripheralManager.state }
    var isBeaconEnabled: Bool = false
    var beaconMinorID: Int = 1
    
    var heartbeat: Int = 0
    
    override init () {
        super.init()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
//            if self?.isBeaconEnabled ?? false {
//                self?.heartbeat += 1
//            }
//        }
    }
    
    func configureBeaconRegion() {
        guard peripheralManager.state == .poweredOn else {
            print("Bluetooth must be enabled.")
            return
        }
        
        peripheralManager.stopAdvertising()
        
        isBeaconEnabled.toggle()
        guard isBeaconEnabled else {
            print("Beacon is deactivated!")
            heartbeat = 0
            return
        }
        
        guard let bundleURL = Bundle.main.bundleIdentifier else {
            print("Can't get bundle identifier!")
            return
        }
        
        print("Activate Beacon UUID: \(beaconUUID), ID: \(beaconMinorID)")
        
        let constraint = CLBeaconIdentityConstraint(
            uuid: beaconUUID,
            major: 1,
            minor: CLBeaconMinorValue(beaconMinorID)
        )
        region = CLBeaconRegion(
            beaconIdentityConstraint: constraint,
            identifier: bundleURL
        )
        let peripheralData = region.peripheralData(withMeasuredPower: nil) as? [String: Any]
        peripheralManager.startAdvertising(peripheralData)
    }
    
    func setBeaconMinorID(_ minorID: Int) -> Bool {
        guard !isBeaconEnabled else {
            print("WARN: Beacon ID cannot be changed while it is enabled")
            return false
        }
        beaconMinorID = minorID
        return true
    }
}

extension PeripheralManager: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralManagerDidUpdateState: \(peripheral.state)")
        if peripheral.state == .poweredOn {
            print("OK power ON")
        } else {
            print("PeripheralManager is not powered on")
        }
            
    }
    
}
