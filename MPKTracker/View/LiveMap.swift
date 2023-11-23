//
//  LiveMap.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import MapKit
import SwiftUI

struct LiveMap: View {
	@EnvironmentObject var connector: MPKConnector
	@State private var trams: [Tram] = []
	@State private var disableButton = false
	
    var body: some View {
		NavigationStack {
			Map {
				ForEach(trams) { tram in
					tram.marker
				}
			}
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Refresh", systemImage: "arrow.clockwise") {
						disableButton = true
						Task {
							await refresh()
						}
						disableButton = false
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
    }
	
	private func refresh() async {
		let result = await connector.getSampleCoords()
		
		Task { @MainActor in
			trams = result
		}
	}
}

#Preview {
    LiveMap()
		.environmentObject(MPKConnector())
}
