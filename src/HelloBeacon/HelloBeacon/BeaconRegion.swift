//
//  BeaconRegion.swift
//  HelloBeacon
//
//  Created by ace on 18/12/2024.
//


import Foundation

// See: https://github.com/lgaches/BeaconEmitter?tab=readme-ov-file
struct BeaconRegion {
    var proximityUUID: NSUUID
    var major: UInt16
    var minor: UInt16

    init(proximityUUID: NSUUID, major: UInt16, minor: UInt16) {
        self.proximityUUID = proximityUUID
        self.major = major
        self.minor = minor
    }

    // See: The Ultimate Guide to Apple’s Core Bluetooth, https://punchthrough.com/core-bluetooth-basics/, for info on 'measuredPower'
    func peripheralDataWithMeasuredPower(_ measuredPower: Int8 = -59) -> [String: Data] {
        let beaconKey = "kCBAdvDataAppleBeaconKey"
        var advBytes = [CUnsignedChar](repeating: 0, count: 21)

        proximityUUID.getBytes(&advBytes)

        advBytes[16] = CUnsignedChar((major >> 8) & 255)
        advBytes[17] = CUnsignedChar(major & 255)

        advBytes[18] = CUnsignedChar((minor >> 8) & 255)
        advBytes[19] = CUnsignedChar(minor & 255)

        advBytes[20] = CUnsignedChar(bitPattern: measuredPower)

        let AdvData = Data(bytes: &advBytes, count: 21)
        return [beaconKey: AdvData]
    }
}
