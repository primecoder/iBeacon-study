//
//  BeaconSettingView.swift
//  HelloBeacon
//
//  Created by ace on 9/12/2024.
//

import SwiftUI

struct BeaconSettingView: View {
    @State var peripheralManager: PeripheralManager
    
    @State private var beaconIDs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var beaconID = 0
    
    var body: some View {
        Picker("Beacon IDs", selection: $beaconID) {
            ForEach(beaconIDs, id: \.self) { id in
                Text("\(id)")
            }
        }
        .disabled(peripheralManager.isBeaconEnabled)
        .pickerStyle(.wheel)
        .onAppear {
            beaconID = peripheralManager.beaconMinorID
        }
        .onChange(of: beaconID, initial: false) { oldValue, newValue in
            if peripheralManager.setBeaconMinorID(beaconID) {
                // Do nothing
            } else {
                beaconID = oldValue
            }
        }
    }
}

#Preview {
    BeaconSettingView(peripheralManager: PeripheralManager())
}
