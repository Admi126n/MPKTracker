//
//  Tram.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 23/11/2023.
//

import MapKit
import SwiftUI

final class Tram: Vehicle {
	init(line lineNumber: String, sideNumber: String, updateDate: Date, lat latitude: Double, lon longitude: Double) {
		super.init(latitude: latitude, lineNumber: lineNumber, longitude: longitude, sideNumber: sideNumber, updateDate: updateDate, "tram")
	}
}
