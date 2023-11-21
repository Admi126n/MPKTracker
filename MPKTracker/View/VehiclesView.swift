//
//  Settings.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import SwiftUI

struct VehiclesView: View {
    var body: some View {
		VStack {
			Text("Here you can choose which buses and trams you want to see on the map")
				.multilineTextAlignment(.center)
			
			Button("Fetch data") {
				let connector = MPKConnector()
				Task {
					let lines = await connector.getAllLines()
					print(lines.trams)
					print(lines.buses)
				}
			}
		}
    }
}

#Preview {
    VehiclesView()
}
