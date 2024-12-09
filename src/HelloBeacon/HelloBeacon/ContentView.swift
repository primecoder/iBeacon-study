//
//  ContentView.swift
//  HelloBeacon
//
//  Created by ace on 9/12/2024.
//

import SwiftUI

struct ContentView: View {
    @State var peripheralManager: PeripheralManager
    var body: some View {
        TabView {
            Tab("Beacon", systemImage: "light.beacon.max") {
                BeaconView(peripheralManager: peripheralManager)
            }
            Tab("Settings", systemImage: "gear") {
                BeaconSettingView(peripheralManager: peripheralManager)
            }
        }
    }
}

#Preview {
    ContentView(peripheralManager: PeripheralManager())
}
