//
//  LiveMap.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import MapKit
import SwiftUI

extension View {
	func annotationBackground() -> some View {
		self
			.frame(width: 44, height: 44)
			.clipShape(.rect(cornerRadius: 15))
	}
}

struct LiveMap: View {
	let refreshTImer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
	let updateTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	@EnvironmentObject var connector: MPKConnector
	@State private var disableButton = false
	@State private var selectedVehicle: Vehicle!
	@State private var timeDelta = 0
	@State private var vehicles: [Vehicle] = []
	
	var body: some View {
		NavigationStack {
			Map {
				ForEach(vehicles) { v in
					Annotation(v.lineNumber, coordinate: v.coordinates) {
						ZStack {
							if v == selectedVehicle {
								Color.green.opacity(0.7)
									.annotationBackground()
							} else {
								Color.secondary.opacity(0.7)
									.annotationBackground()
							}
							
							Image(systemName: v.symbolName)
						}
						.onTapGesture {
							selectedVehicle = v
						}
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button(I18n.refresh, systemImage: "arrow.clockwise") {
						Task {
							await refresh()
						}
					}
					.disabled(disableButton)
				}
			}
		}
		.onAppear {
			Task {
				await refresh()
			}
		}
		.onReceive(refreshTImer) { _ in
			Task {
				await refresh()
			}
		}
		.onReceive(updateTimer) { _ in
			if let selectedVehicle = selectedVehicle {
				timeDelta = -Int(selectedVehicle.updateDate.timeIntervalSinceNow)
			}
		}
		.sheet(item: $selectedVehicle) { v in
			let minutes = timeDelta / 60
			
			List {
				Text("Line number: **\(v.lineNumber)**")
				Text("Side number: **\(v.sideNumber)**")
				Text("Updated \(minutes)min and \(timeDelta - minutes * 60)s ago")
			}
			.presentationDetents([.medium])
		}
	}
	
	private func refresh() async {
		let result = await connector.getSelectedVehicles()
		disableButton = true
		Task { @MainActor in
			withAnimation {
				vehicles = result
			}
		}
		disableButton = false
	}
}

#Preview {
	LiveMap()
		.environmentObject(MPKConnector())
}

