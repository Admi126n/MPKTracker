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

struct MPKConnector {
	private let urlBase = "https://www.wroclaw.pl/open-data/api/action/datastore_search?resource_id=17308285-3977-42f7-81b7-fdd168c210a2"
	private let urlLimit = "&limit=1000"
	
	private func fetchData<T: Codable>(from link: String, using decoder: JSONDecoder = JSONDecoder()) async throws -> T {
		guard let safeUrl = URL(string: link) else { throw TempErrors.notImplememnted }
		
		guard let (data, _) = try? await URLSession.shared.data(from: safeUrl) else { throw TempErrors.notImplememnted }
		
		guard let decoded = try? JSONDecoder().decode(T.self, from: data) else { throw TempErrors.notImplememnted }
		
		return decoded
	}
	
	
	/// Gets all available tram and bus lines from MPK API
	/// - Returns: tuple with sorted arrays of available lines
	func getAllLines() async -> (buses: [String], trams: [Int]) {
		var buses: Set<String> = ([])
		var trams: Set<Int> = ([])
		
		if let results: FetchResult = try? await fetchData(from: urlBase + urlLimit) {
			for result in results.result.records {
				let name = result.lineNumber
				
				// not valid because of empty name
				guard !name.isEmpty else { continue }
				guard name != "None" else { continue }
				// not valid because too old
				guard result.updateDate.timeIntervalSinceNow <= 15 * 60 else { continue }
				
				if let number = Int(name) {
					// all trams in Wroclaw have numbers less than 100
					if number < 100 {
						trams.insert(number)
					} else {
						buses.insert(name)
					}
				} else {
					// in Wroclaw only buses have letters as names
					buses.insert(name)
				}
			}
		}
		
		return (buses.sorted(), trams.sorted())
	}
}

// MARK: - Data structs

fileprivate struct FetchResult: Codable {
	let result: Records
}

fileprivate struct Records: Codable {
	let records: [Record]
}

fileprivate struct Record: Codable {
	private enum CodingKeys: CodingKey {
		case Brygada
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
	let squad: String
	let updateDate: Date
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.squad = try container.decode(String.self, forKey: .Brygada)
		
		self.lineNumber = try container.decode(String.self, forKey: .Nazwa_Linii)
		self.sideNumber = try container.decode(String.self, forKey: .Nr_Boczny)
		self.plateNumber = try container.decode(String.self, forKey: .Nr_Rej)
		self.longitude = try container.decode(Double.self, forKey: .Ostatnia_Pozycja_Dlugosc)
		self.latitude = try container.decode(Double.self, forKey: .Ostatnia_Pozycja_Szerokosc)
		
		let dateString = try container.decode(String.self, forKey: .Data_Aktualizacji)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSSSSS"
		self.updateDate = dateFormatter.date(from: dateString)!
	}
	
	func encode(to encoder: Encoder) throws {
		// TODO: implement
		fatalError("Not implemented")
	}
}
