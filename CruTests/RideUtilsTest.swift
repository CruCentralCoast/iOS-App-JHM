//
//  RideUtilsTest.swift
//  Cru
//
//  Created by Max Crane on 3/8/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import XCTest

class RideUtilsTest: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPostAndRemoveRideOffer() {
        //test post
        var readyExpectation = self.expectationWithDescription("post a ride")
        var rideId: String?
        
        RideUtils.postRideOffer("563b11135e926d03001ac15c", name: "Joe Schmo", phone: "1234567890", seats: 5, location: ["postcode":"93401", "state":"CA", "suburb":"SLO", "street1":"1 Grand ave."], radius: 3, direction: "both", handler :{ success in
            XCTAssert(success)
            readyExpectation.fulfill()
            },
            idhandler: { id in
                rideId = id
        })
        
        waitForExpectationsWithTimeout(5) {error in
            XCTAssertNil(error, "Error")
        }
        
        
        //test drop
        readyExpectation = self.expectationWithDescription("drop a ride")
        
        XCTAssertNotNil(rideId)
        
        RideUtils.leaveRideDriver(rideId!, handler: { success in
            XCTAssert(success)
            readyExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5) {error in
            XCTAssertNil(error, "Error")
        }
    }
    
    func testAddAndDropPassenger(){
        var rideId: String?
        var passId: String?
        
        //posts a ride
        var readyExpectation = self.expectationWithDescription("post a ride")
        RideUtils.postRideOffer("563b11135e926d03001ac15c", name: "Joe Schmo", phone: "1234567890", seats: 5, location: ["postcode":"93401", "state":"CA", "suburb":"SLO", "street1":"1 Grand ave."], radius: 3, direction: "both", handler :{ success in
            XCTAssert(success)
            readyExpectation.fulfill()
            },
            idhandler: { id in
                rideId = id
        })
        waitForExpectationsWithTimeout(5) {error in
            XCTAssertNil(error, "Error")
        }
        
        //add passenger
        readyExpectation = self.expectationWithDescription("join a ride")
        RideUtils.joinRide("Test Tester", phone: "1234567890", direction: "to",  rideId: rideId!, handler: { obj in
                readyExpectation.fulfill()
            }, passIdHandler: { id in
                passId = id
        })
        waitForExpectationsWithTimeout(5) {error in
            XCTAssertNil(error, "Error")
        }
        
        //drop passenger
        readyExpectation = self.expectationWithDescription("leave a ride")
        RideUtils.leaveRide(passId!, rideid: rideId!, handler: { success in
            print("here 3")
            XCTAssert(success)
            readyExpectation.fulfill()
        })
        waitForExpectationsWithTimeout(5) {error in
            XCTAssertNil(error, "Error")
        }
        
        
        //removes the ride
        readyExpectation = self.expectationWithDescription("drop a ride")
        
        XCTAssertNotNil(rideId)
        
        RideUtils.leaveRideDriver(rideId!, handler: { success in
            XCTAssert(success)
            readyExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5) {error in
            XCTAssertNil(error, "Error")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
