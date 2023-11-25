//
//  ContentView.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import SwiftUI

struct ContentView: View {
	@StateObject var mpkConnector = MPKConnector()
	
    var body: some View {
		TabView {
			LiveMap()
				.tabItem { Label(I18n.map, systemImage: "map") }
			
			VehiclesView()
				.tabItem { Label(I18n.vehicles, systemImage: "lightrail") }
		}
		.environmentObject(mpkConnector)
    }
}

#Preview {
    ContentView()
}
