//
//  ContentView.swift
//  HelloBeacon
//
//  Created by ace on 6/12/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var peripheralManager = PeripheralManager()
    
    var body: some View {
        VStack {
            Button {
                peripheralManager.configureBeaconRegion()
            } label: {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Enable Beacon")
                }
                .padding()
            }

            Text("Peripheral state: \(peripheralManager.state.rawValue)")
            Text("Heartbeat: \(peripheralManager.heartbeat)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
