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
    
    let beaconUUID = UUID(uuidString: "8B96586C-2AAB-488F-80BA-7774290D0C8D")!
    var peripheralManager: CBPeripheralManager!
    var region: CLBeaconRegion!
    
    var state: CBManagerState { peripheralManager.state }
    var isBeaconEnabled: Bool = false
    var beaconMinorID: Int = 1
    
    var locationManager = CLLocationManager()
    var beaconRegions = [CLBeaconRegion]()
    var beacons = [CLProximity: [CLBeacon]]()
    
    private static let allIDs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    private var registerredIDs: Set<Int> = []
    
    var availableIDs: [Int] {
        PeripheralManager.allIDs.filter { !registerredIDs.contains($0) }
    }

    override init () {
        super.init()
        
        peripheralManager = CBPeripheralManager(
            delegate: self, queue: nil, options: nil)
        locationManager.delegate = self
        initBeaconMonitoring()
    }
    
    @discardableResult
    func configureBeaconRegion() -> Bool {
        guard peripheralManager.state == .poweredOn else {
            print("Bluetooth must be enabled.")
            return false
        }
        
        guard !self.registerredIDs.contains(beaconMinorID) else {
            print("ERROR: beacon ID has already been registered")
            return false
        }
        
        peripheralManager.stopAdvertising()
        isBeaconEnabled.toggle()
        guard isBeaconEnabled else {
            print("Beacon is deactivated!")
            return false
        }
        
        guard let bundleURL = Bundle.main.bundleIdentifier else {
            print("Can't get bundle identifier!")
            return false
        }
        
        print("Activate Beacon UUID: \(beaconUUID), ID: \(beaconMinorID)")
        
        let beaconRegion = CLBeaconRegion(uuid: beaconUUID, major: 1, minor: CLBeaconMinorValue(beaconMinorID), identifier: bundleURL)
        beaconRegions.append(beaconRegion)

#if os(macOS)
        if let proximityUUID = NSUUID(uuidString: beaconUUID.uuidString) {
            let region = BeaconRegion(proximityUUID: proximityUUID, major: 1, minor: UInt16(beaconMinorID))
            peripheralManager.startAdvertising(region.peripheralDataWithMeasuredPower())
        }
#else
        let peripheralData = beaconRegion.peripheralData(withMeasuredPower: nil) as? [String: Any]
        peripheralManager.startAdvertising(peripheralData)
#endif
        return true
    }
    
    @discardableResult
    func setBeaconMinorID(_ minorID: Int) -> Bool {
        guard !isBeaconEnabled else {
            print("WARN: Beacon ID cannot be changed while it is enabled")
            return false
        }
        beaconMinorID = minorID
        return true
    }
    
    private func initBeaconMonitoring() {
        self.locationManager.requestWhenInUseAuthorization()
        
        let beaconRegion = CLBeaconRegion(uuid: beaconUUID, identifier: beaconUUID.uuidString)
        self.beaconRegions.append(beaconRegion)
        self.locationManager.startMonitoring(for: beaconRegion)
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

extension PeripheralManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        guard let beaconRegion = region as? CLBeaconRegion else { return }
        if state == .inside {
            manager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid))
        } else {
            manager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        print("didRange: beacons: \(beacons)")
        self.beacons.removeAll()
        self.registerredIDs.removeAll()
        for range in [CLProximity.unknown, .immediate, .near, .far] {
            let proximityBeacons = beacons.filter { $0.proximity == range }
            if !proximityBeacons.isEmpty {
                self.beacons[range] = proximityBeacons
                for beacon in proximityBeacons {
                    self.registerredIDs.insert(Int(truncating: beacon.minor))
                }
            }
        }
    }
}
