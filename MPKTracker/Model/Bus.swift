//
//  Bus.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 23/11/2023.
//

import MapKit
import SwiftUI

final class Bus: Vehicle {
	private(set) var plate: String
	
	init(line lineNumber: String, sideNumber: String, plate: String, lat latitude: Double, lon longitude: Double) {
		self.plate = plate
		
		super.init(latitude: latitude, lineNumber: lineNumber, longitude: longitude, sideNumber: sideNumber, "bus.fill")
	}
}
