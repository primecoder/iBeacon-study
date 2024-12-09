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
        VStack {
            Picker("Beacon IDs", selection: $beaconID) {
                ForEach(beaconIDs, id: \.self) { id in
                    Text("\(id)")
                }
            }
            .disabled(peripheralManager.isBeaconEnabled)
            .pickerStyle(.wheel)
            
            Button("Change Beacon's ID") {
                peripheralManager.setBeaconMinorID(beaconID)
            }
            .disabled(peripheralManager.isBeaconEnabled)
        }
        .onAppear {
            beaconID = peripheralManager.beaconMinorID
        }
        
    }
}

#Preview {
    BeaconSettingView(peripheralManager: PeripheralManager())
}
