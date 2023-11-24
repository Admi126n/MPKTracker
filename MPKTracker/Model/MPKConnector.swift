//
//  MPKConnector.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import Foundation

enum TempErrors: Error {
	case notImplememnted
}

enum VehicleType {
	case bus
	case tram
}

class MPKConnector: ObservableObject {
	private let coordMargin = 1.0
	private let cityLat = 51.0
	private let cityLon = 17.0
	private let urlBase = "https://www.wroclaw.pl/open-data/api/action/datastore_search?resource_id=17308285-3977-42f7-81b7-fdd168c210a2"
	private let urlLimit = "&limit=1000"
	
	var selectedLines: [String] = []
	
	private var dateMargin: Date {
		Date.now.addingTimeInterval(-15 * 60)
	}
	
	/// Creates filter part of the url
	private func urlFilter(for line: String) -> String {
		"&filters={\"Nazwa_Linii\":\"\(line)\"}"
	}
	
	
	/// Generic method for fetching data from given link
	private func fetchData<T: Codable>(from link: String, using decoder: JSONDecoder = JSONDecoder()) async throws -> T {
		guard let safeUrl = URL(string: link) else { throw TempErrors.notImplememnted }
		
		guard let (data, _) = try? await URLSession.shared.data(from: safeUrl) else { throw TempErrors.notImplememnted }
		
		guard let decoded = try? JSONDecoder().decode(T.self, from: data) else { throw TempErrors.notImplememnted }
		
		return decoded
	}
	
	
	/// Checks vehicle type based on line number
	/// - Parameter type: line number
	/// - Returns: vehicle type
	private func get(line type: String) -> VehicleType {
		if let number = Int(type) {
			// all trams in Wroclaw have numbers less than 100
			if number < 100 {
				return .tram
			} else {
				return .bus
			}
		} else {
			// in Wroclaw only buses have letters as names
			return .bus
		}
	}
	
	
	/// Validates given name
	/// - Returns: false if name is empty or equal to 'None'
	private func validate(line name: String) -> Bool {
		!(name.isEmpty || name == "None")
	}
	
	
	/// Validates given update date
	/// - Returns: false if date is older than margin
	private func validate(update date: Date) -> Bool {
		date >= dateMargin
	}
	
	
	/// Validates given coordinates
	/// - Returns: false if coordinates are too small or too big
	private func validate(lattitude: Double, longitude: Double) -> Bool {
		return lattitude >= cityLat - coordMargin
		&& lattitude <= cityLat + coordMargin
		&& longitude >= cityLon - coordMargin
		&& longitude <= cityLon + coordMargin
	}
	
	
	/// Gets all available tram and bus lines from MPK API
	/// - Returns: tuple with sorted arrays of available lines
	func getAllLines() async -> (buses: [String], trams: [Int]) {
		var buses: Set<String> = ([])
		var trams: Set<Int> = ([])
		
		if let results: FetchResult = try? await fetchData(from: urlBase + urlLimit) {
			for result in results.result.records {
				let name = result.lineNumber
				
				guard validate(line: name) else { continue }
				guard validate(update: result.updateDate) else { continue }
				guard validate(lattitude: result.latitude, longitude: result.longitude) else { continue }
				
				switch get(line: name) {
				case .bus:
					buses.insert(name)
				case .tram:
					trams.insert(Int(name)!)
				}
			}
		}
		
		return (buses.sorted(), trams.sorted())
	}
	
	
	/// Fetches all selected vehicles data
	func getSelectedVehicles() async -> [Vehicle] {
		var result: [Vehicle] = []
		
		for line in selectedLines {
			if let results: FetchResult = try? await fetchData(from: urlBase + urlLimit + urlFilter(for: line)) {
				for r in results.result.records {
					guard validate(line: r.lineNumber) else { continue }
					guard validate(update: r.updateDate) else { continue }
					guard validate(lattitude: r.latitude, longitude: r.longitude) else { continue }
					
					switch get(line: line) {
					case .bus:
						result.append(Bus(line: r.lineNumber, sideNumber: r.sideNumber, plate: r.plateNumber, lat: r.latitude, lon: r.longitude))
					case .tram:
						result.append(Tram(line: r.lineNumber, sideNumber: r.sideNumber, lat: r.latitude, lon: r.longitude))
					}
				}
			}
		}
		return result
	}
}

// MARK: - Data structs

fileprivate struct FetchResult: Codable {
	let result: Records
}

fileprivate struct Records: Codable {
	let records: [FetchedVehicle]
}

fileprivate struct FetchedVehicle: Codable {
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

// MARK: - getters for tests

#if DEBUG
extension MPKConnector {
	var testCityLat: Double {
		cityLat
	}
	
	var testCityLon: Double {
		cityLon
	}
	
	var testCoordMargin: Double {
		coordMargin
	}
	
	var testDateMargin: Date {
		dateMargin
	}
	
	func testCheck(line type: String) -> VehicleType {
		get(line: type)
	}
	
	func testValidate(line: String) -> Bool {
		validate(line: line)
	}
	
	func testValidate(update date: Date) -> Bool {
		validate(update: date)
	}
	
	func testValidate(lattitude: Double, longitude: Double) -> Bool {
		validate(lattitude: lattitude, longitude: longitude)
	}
}
#endif
