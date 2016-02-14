//
//  EventCreationTestCases.swift
//  Cru
//
//  Created by Deniz Tumer on 2/12/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import XCTest

class EventCreationTestCases: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testCreateEvent() {
        //create an event from the name/id constructor
        var event = Event(name: "Some Test Event", id: "1")
        XCTAssertEqual(event?.name, "Some Test Event")
        XCTAssertEqual(event?.id, "1")
        
        //create an event from the long constructor
        event = Event(id: "1", name: "Some Test Event", image: nil, startDate: "2014-06-01T05:00:00.000Z", endDate: "2014-06-01T09:00:00.000Z", street: "1230 Monte Vista Place", suburb: "SLO", postcode: "93405", description: "This is a test event.", url: "", imageUrl: nil)
        XCTAssertEqual(event?.id, "1")
        XCTAssertEqual(event?.name, "Some Test Event")
        XCTAssertNil(event?.image)
    }
}
