//
//  LiveMap.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import MapKit
import SwiftUI

struct LiveMap: View {
	let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
	
	@EnvironmentObject var connector: MPKConnector
	@State private var vehicles: [Vehicle] = []
	@State private var disableButton = false
	
    var body: some View {
		NavigationStack {
			Map {
				ForEach(vehicles) { v in
					Annotation(v.lineNumber, coordinate: v.coordinates) {
						ZStack {
							Color.secondary.opacity(0.7)
								.frame(width: 44, height: 44)
								.clipShape(.rect(cornerRadius: 15))
							
							Image(systemName: v.symbolName)
						}
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Refresh", systemImage: "arrow.clockwise") {
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
		.onReceive(timer) { _ in
			Task {
				await refresh()
			}
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

