//
//  FetchResult.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 26/11/2023.
//

import Foundation

struct FetchResult: Codable {
	let result: Records
}

struct Records: Codable {
	let records: [FetchedVehicle]
}

struct FetchedVehicle: Codable {
	private enum CodingKeys: CodingKey {
		case Data_Aktualizacji
		case Nazwa_Linii
		case Nr_Boczny
		case Nr_Rej
		case Ostatnia_Pozycja_Dlugosc
		case Ostatnia_Pozycja_Szerokosc
	}
	
	let latitude: Double
	let lineNumber: String
	let longitude: Double
	let plateNumber: String
	let sideNumber: String
	let updateDate: Date
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.lineNumber = try container.decode(String.self, forKey: .Nazwa_Linii)
		self.sideNumber = try container.decode(String.self, forKey: .Nr_Boczny)
		self.plateNumber = try container.decode(String.self, forKey: .Nr_Rej)
		self.longitude = try container.decode(Double.self, forKey: .Ostatnia_Pozycja_Dlugosc)
		self.latitude = try container.decode(Double.self, forKey: .Ostatnia_Pozycja_Szerokosc)
		
		let dateString = try container.decode(String.self, forKey: .Data_Aktualizacji)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSSSSS"
		
		self.updateDate = dateFormatter.date(from: dateString) ?? Date(timeInterval: -16 * 60, since: .now)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(latitude, forKey: .Ostatnia_Pozycja_Szerokosc)
		try container.encode(lineNumber, forKey: .Nazwa_Linii)
		try container.encode(longitude, forKey: .Ostatnia_Pozycja_Dlugosc)
		try container.encode(plateNumber, forKey: .Nr_Rej)
		try container.encode(sideNumber, forKey: .Nr_Boczny)
		try container.encode(updateDate, forKey: .Data_Aktualizacji)
	}
}
