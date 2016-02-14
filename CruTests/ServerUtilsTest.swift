//
//  DBUtilsTest.swift
//  Cru
//
//  Created by Peter Godkin on 11/29/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import XCTest
import UIKit

class DBUtilsTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testExample() {
        XCTAssert(true)
    }

    func testDateFromString() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let dateComps : NSDateComponents? = ServerUtils.dateFromString("2015-10-17T12:00:00.000Z")
        
        XCTAssertEqual(2015, dateComps!.year)
        XCTAssertEqual(10, dateComps!.month)
        XCTAssertEqual(17, dateComps!.day)
        XCTAssertEqual(12, dateComps!.hour)
        XCTAssertEqual(0, dateComps!.minute)
    }
    
}
