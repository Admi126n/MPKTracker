//
//  Bus.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 23/11/2023.
//

import MapKit
import SwiftUI

struct Bus: Vehicle {
	var id = UUID()
	let latitude: Double
	let lineNumber: String
	let longitude: Double
	var marker: Marker<Label<Text, Image>>
	
	init(lineNumber: String, latitude: Double, longitude: Double) {
		self.lineNumber = lineNumber
		self.latitude = latitude
		self.longitude = longitude
		self.marker = Marker(
			lineNumber,
			systemImage: "bus.fill",
			coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		)
	}
}
