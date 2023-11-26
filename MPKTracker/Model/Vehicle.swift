//
//  Vehicle.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 23/11/2023.
//

import MapKit
import SwiftUI

class Vehicle: Identifiable {
	private(set) var id: UUID
	private(set) var lineNumber: String
	private(set) var sideNumber: String
	private(set) var symbolName: String
	private(set) var updateDate: Date
	private var latitude: Double
	private var longitude: Double
	
	var coordinates: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(
			latitude: latitude,
			longitude: longitude
		)
	}
	
	init(latitude: Double, lineNumber: String, longitude: Double, sideNumber: String, updateDate: Date, _ symbolName: String = "questionmark.circle.fill") {
		self.id = UUID()
		self.latitude = latitude
		self.lineNumber = lineNumber
		self.longitude = longitude
		self.sideNumber = sideNumber
		self.symbolName = symbolName
		self.updateDate = updateDate
	}
	
	func set(latitude: Double) {
		self.latitude = latitude
	}
	
	func set(longitude: Double) {
		self.longitude = longitude
	}
}

// MARK: - Equatable protocol

extension Vehicle: Equatable {
	static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
		lhs.sideNumber == rhs.sideNumber && lhs.lineNumber == rhs.lineNumber
	}
}
