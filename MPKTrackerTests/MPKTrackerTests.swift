//
//  MPKTrackerTests.swift
//  MPKTrackerTests
//
//  Created by Adam Tokarski on 24/11/2023.
//

import XCTest
@testable import MPKTracker

final class MPKTrackerTests: XCTestCase {

	private var sysUnderTest: MPKConnector!
	
    override func setUp() {
        sysUnderTest = MPKConnector()
    }

    override func tearDown() {
        sysUnderTest = nil
    }

	func testMPKConnectorCheckLineType_WhenLetterBusGiven_ShouldReturnBus() {
		let result = sysUnderTest.testCheck(line: "D")
		
		XCTAssertEqual(result, .bus, "Should return bus but tram is returned")
    }

	func testMPKConnectorCheckLineType_WhenNumberBusGiven_ShouldReturnBus() {
		let result = sysUnderTest.testCheck(line: "110")
		
		XCTAssertEqual(result, .bus, "Should return bus but tram is returned")
	}
	
	func testMPKConnectorCheckLineType_WhenTramGiven_ShouldReturnTram() {
		let result = sysUnderTest.testCheck(line: "5")
		
		XCTAssertEqual(result, .tram, "Should return bus but tram is returned")
	}
	
	func testMPKConnectorValidateLine_WhenValidLineNumberGiven_ShouldReturnTrue() {
		let result = sysUnderTest.testValidate(line: "112")
		
		XCTAssertTrue(result)
	}
	
	func testMPKConnectorValidateLine_WhenEmptyLineNumberGiven_ShouldReturnFalse() {
		let result = sysUnderTest.testValidate(line: "")
		
		XCTAssertFalse(result)
	}
	
	func testMPKConnectorValidateLine_WhenNoneLineNumberGiven_ShouldReturnFalse() {
		let result = sysUnderTest.testValidate(line: "None")
		
		XCTAssertFalse(result)
	}

	func testMPKConnectorValidateLine_WhenTooOldDateUpdateGiven_ShouldReturnFalse() {
		let tooOldDate = sysUnderTest.testDateMargin.addingTimeInterval(-1)
		
		let result = sysUnderTest.testValidate(update: tooOldDate)
		
		XCTAssertFalse(result)
	}
	
	func testMPKConnectorValidateLine_WhenWrongCoordsGiven_ShouldReturnFalse() {
		let lattitude = 52.0
		let longitude = 15.0
		
		let result = sysUnderTest.testValidate(lattitude: lattitude, longitude: longitude)
		
		XCTAssertFalse(result)
	}
}
