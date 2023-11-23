//
//  Settings.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import SwiftUI

struct VehiclesView: View {
	@EnvironmentObject var connector: MPKConnector
	@State private var buses: [String] = []
	@State private var trams: [Int] = []
	
	var body: some View {
		VStack {
			Text("Here you can choose which buses and trams you want to see on the map")
				.multilineTextAlignment(.center)
			
			Button("Fetch data") {
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
						Button {
							if connector.selectedLines.contains(bus) {
								if let index = connector.selectedLines.firstIndex(of: bus) {
									connector.selectedLines.remove(at: index)
								}
							} else {
								connector.selectedLines.append(bus)
							}
						} label: {
							Text(bus)
						}
					}
				}
				
				Section("Trams") {
					ForEach(trams, id: \.self) { tram in
						Button {
							if connector.selectedLines.contains("\(tram)") {
								if let index = connector.selectedLines.firstIndex(of: "\(tram)") {
									connector.selectedLines.remove(at: index)
								}
							} else {
								connector.selectedLines.append("\(tram)")
							}
						} label: {
							Text("\(tram)")
						}
					}
				}
			}
		}
	}
}

#Preview {
	VehiclesView()
		.environmentObject(MPKConnector())
}
