//
//  Settings.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import SwiftUI

struct VehiclesView: View {
	@State private var buses: [String] = []
	@State private var trams: [Int] = []
	
    var body: some View {
		VStack {
			Text("Here you can choose which buses and trams you want to see on the map")
				.multilineTextAlignment(.center)
			
			Button("Fetch data") {
				let connector = MPKConnector()
				Task {
					let lines = await connector.getAllLines()
					
					Task { @MainActor in
						buses = lines.buses
						trams = lines.trams
					}
				}
			}
			
			List {
				Section("Buses") {
					ForEach(buses, id: \.self) { bus in
						Text(bus)
					}
				}
				
				Section("Trams") {
					ForEach(trams, id: \.self) { tram in
						Text("\(tram)")
					}
				}
			}
		}
    }
}

#Preview {
    VehiclesView()
}
