//
//  Settings.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import SwiftUI

fileprivate struct LineButton: View {
	let title: String
	
	@EnvironmentObject var connector: MPKConnector
	@State private var selected = false
	
	var body: some View {
		Button {
			if connector.selectedLines.contains(String(title)) {
				if let index = connector.selectedLines.firstIndex(of: String(title)) {
					connector.selectedLines.remove(at: index)
				}
			} else {
				connector.selectedLines.append(String(title))
			}
			selected.toggle()
		} label: {
			Text(title)
				.font(.headline)
				.padding(5)
				.frame(width: 70)
				.background(selected ? .green : .gray)
				.clipShape(.rect(cornerRadius: 10))
				.tint(.white)
		}
	}
}

struct VehiclesView: View {
	@EnvironmentObject var connector: MPKConnector
	@State private var buses: [String] = []
	@State private var trams: [Int] = []
	
	var body: some View {
		NavigationStack {
			ScrollView {
				Label("Buses", systemImage: "bus.fill")
					.font(.title)
				
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
					ForEach(buses, id: \.self) { bus in
						LineButton(title: bus)
					}
				}
				.padding(.horizontal)
				
				Label("Trams", systemImage: "lightrail")
					.font(.title)
				
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
					ForEach(trams, id: \.self) { tram in
						LineButton(title: "\(tram)")
					}
				}
				.padding(.horizontal)
				
			}
			.onAppear {
				Task {
					let temp = await connector.getAllLines()
					
					Task { @MainActor in
						buses = temp.buses
						trams = temp.trams
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
