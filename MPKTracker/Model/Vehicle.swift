//
//  Vehicle.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 23/11/2023.
//

import MapKit
import SwiftUI

class Vehicle: Identifiable {
	private(set) var symbolName: String
	private(set) var id: UUID
	private(set) var latitude: Double
	private(set) var lineNumber: String
	private var longitude: Double
	private var sideNumber: String
	
	var coordinates: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(
			latitude: latitude,
			longitude: longitude
		)
	}
	
	init(latitude: Double, lineNumber: String, longitude: Double, sideNumber: String, _ symbolName: String = "questionmark.circle.fill") {
		self.id = UUID()
		self.latitude = latitude
		self.lineNumber = lineNumber
		self.longitude = longitude
		self.sideNumber = sideNumber
		self.symbolName = symbolName
	}
	
	func set(latitude: Double) {
		self.latitude = latitude
	}
	
	func set(longitude: Double) {
		self.longitude = longitude
	}
}
