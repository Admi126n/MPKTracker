//
//  MPKConnector.swift
//  MPKTracker
//
//  Created by Adam Tokarski on 21/11/2023.
//

import Foundation

fileprivate struct FetchResult: Codable {
	let result: Records
}

fileprivate struct Records: Codable {
	let records: [Record]
}

fileprivate struct Record: Codable {
	let Brygada: String
	let Data_Aktualizacji: String
	let Nazwa_Linii: String
	let Nr_Boczny: String
	let Nr_Rej: String
	let Ostatnia_Pozycja_Dlugosc: Double
	let Ostatnia_Pozycja_Szerokosc: Double
	
	var date: Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSSSSS"
		
		return dateFormatter.date(from: Data_Aktualizacji)!
	}
}

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
	func getAllLines() async -> (trams: [Int], buses: [String]) {
		let decoder = JSONDecoder()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSSSSS"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		
		var trams: Set<Int> = ([])
		var buses: Set<String> = ([])
		
		if let results: FetchResult = try? await fetchData(from: urlBase + urlLimit, using: decoder) {
			for result in results.result.records {
				print(result.date)
				let name = result.Nazwa_Linii
				
				guard !name.isEmpty else { continue }
				guard name != "None" else { continue }
				
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
		
		return (trams.sorted(), buses.sorted())
	}
}
