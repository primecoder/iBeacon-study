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
    @State private var scale = 1.0
    @State private var iconOpacity: Double = 0.1

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
                        .foregroundStyle(.tint.opacity(iconOpacity))
                        .frame(width: 50, height: 50)
                        .scaleEffect(scale)
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
        .onChange(of: peripheralManager.isBeaconEnabled, initial: true) { oldValue, newValue in
            if newValue {
                let animation = Animation.easeInOut(duration: 1)
                let repeated = animation.repeatForever(autoreverses: true)
                withAnimation(repeated) {
                    scale = 1.2
                    iconOpacity = 0.2
                }
            } else {
                let animation = Animation.easeInOut(duration: 1)
                withAnimation(animation) {
                    scale = 1.0
                    iconOpacity = 1.0
                }
            }
        }
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
