//
//  RideTest.swift
//  Cru
//
//  Created by Max Crane on 3/8/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import XCTest

class RideTest: XCTestCase {
    let rideDict = ["location": ["postcode":"93401", "state":"CA", "suburb":"SLO", "street1":"1 Grand ave."],"_id": "blah", "direction": "both", "seats": 3, "radius": 2, "gcm_id": "blah", "driverNumber": "1234567890", "driverName": "Joe Schmo", "event": "replacethis", "time": "2016-03-06T16:10:41.000Z", "passengers":[]]
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRideHasSeats() {
        let ride = Ride(dict: rideDict)
        XCTAssert(ride!.hasSeats())
    }
    
    func testRideNumSeatsLeft(){
        let ride = Ride(dict: rideDict)
        XCTAssertEqual(ride!.seatsLeft(), 3)
    }
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}