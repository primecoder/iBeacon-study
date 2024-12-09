//
//  ContentView.swift
//  HelloBeacon
//
//  Created by ace on 6/12/2024.
//

import SwiftUI
import CoreLocation

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
                    Text("Beacon \(peripheralManager.beaconMinorID)")
                }
                .tint(beaconFgColor)
                .padding()
            }
            
            Divider()
            List {
                ForEach(Array(peripheralManager.beacons.keys), id: \.self) { key in
                    if let beacon = peripheralManager.beacons[key]?.first {
                        HStack {
                            Text("Beacon \(beacon.minor)")
                            Text("\(getProximityClass(proximity:     beacon.proximity))")
                            Text("(\(getProximityDistance(accuracy: beacon.accuracy)) m)")
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .padding()
    }
    
    private func getProximityDistance(accuracy: CLLocationAccuracy) -> String {
        let distanceString = String(format: "%.2f", accuracy)
        return distanceString
    }
    
    private func getProximityClass(proximity: CLProximity) -> String {
        switch proximity {
        case .immediate: return "Immediate"
        case .near: return "Near"
        case .far: return "Far"
        case .unknown: return "Unknown"
        @unknown default:
            return "Future Unknown"
        }
    }
}


#Preview {
    BeaconView(peripheralManager: PeripheralManager())
}
