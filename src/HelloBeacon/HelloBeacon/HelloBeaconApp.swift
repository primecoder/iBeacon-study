//
//  HelloBeaconApp.swift
//  HelloBeacon
//
//  Created by ace on 6/12/2024.
//

import SwiftUI

@main
struct HelloBeaconApp: App {
    @State var peripheralManager = PeripheralManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(peripheralManager: peripheralManager)
        }
    }
}
