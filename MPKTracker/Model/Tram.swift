//
//  Tram.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 23/11/2023.
//

import MapKit
import SwiftUI

struct Tram: Vehicle {
	var id = UUID()
	var latitude: Double
	var lineNumber: String
	var longitude: Double
	var marker: Marker<Label<Text, Image>>
	
	init(lineNumber: String, latitude: Double, longitude: Double) {
		self.lineNumber = lineNumber
		self.latitude = latitude
		self.longitude = longitude
		self.marker = Marker(
			lineNumber,
			systemImage: "tram",
			coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		)
	}
}
