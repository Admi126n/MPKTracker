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
				.tabItem { Label("Live map", systemImage: "map") }
			
			VehiclesView()
				.tabItem { Label("Vehicles", systemImage: "lightrail") }
		}
		.environmentObject(mpkConnector)
    }
}

#Preview {
    ContentView()
}
