//
//  Vehicle.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 23/11/2023.
//

import MapKit
import SwiftUI

protocol Vehicle: Identifiable {
	var latitude: Double { get }
	var lineNumber: String { get }
	var longitude: Double { get }
	var marker: Marker<Label<Text, Image>> { get }
	
	init(lineNumber: String, latitude: Double, longitude: Double)
}
