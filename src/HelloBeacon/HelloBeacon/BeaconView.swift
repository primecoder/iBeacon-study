//
//  ContentView.swift
//  HelloBeacon
//
//  Created by ace on 6/12/2024.
//

import SwiftUI

struct BeaconView: View {
    
    @State var peripheralManager: PeripheralManager

    var beaconImageName: String {
        peripheralManager.isBeaconEnabled ? "light.beacon.min.fill" : "light.beacon.min"
    }
    
    var beaconFgColor: Color {
        peripheralManager.isBeaconEnabled ? .blue : .gray
    }
    
    var body: some View {
        VStack {
            Button {
                peripheralManager.configureBeaconRegion()
            } label: {
                VStack {
                    Image(systemName: beaconImageName)
                        .resizable()
                        .foregroundStyle(.tint)
                        .frame(width: 50, height: 50)
                    Text("Beacon: \(peripheralManager.beaconMinorID)")
                }
                .tint(beaconFgColor)
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    BeaconView(peripheralManager: PeripheralManager())
}
