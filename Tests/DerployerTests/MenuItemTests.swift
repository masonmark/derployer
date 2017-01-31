// MenuItemTests.swift Created by mason on 2017-01-31. 

import XCTest
@testable import Derployer

class MenuItemTests: XCTestCase {
    
    func test_validation() {
        
        let isLessThanFive: MenuItemValidator = { input in
            guard let i = Int(input) else {
                return false
            }
            return i < 5
        }
        
        let lessThanFive = MenuItem("<5", value: "1", validator: isLessThanFive)
        let whatever     = MenuItem("<5", value: "1")
        
        XCTAssertTrue(lessThanFive.validate("0"))
        XCTAssertTrue(lessThanFive.validate("1"))
        XCTAssertTrue(lessThanFive.validate("2"))
        XCTAssertTrue(lessThanFive.validate("3"))
        XCTAssertTrue(lessThanFive.validate("4"))
        XCTAssertFalse(lessThanFive.validate("5"))
        XCTAssertFalse(lessThanFive.validate("#assclownPOTUS"))
        
        XCTAssertTrue(whatever.validate("#assclownPOTUS"))
    }
}


extension MenuItemTests {
    
    static var allTests : [(String, (MenuItemTests) -> () throws -> Void)] {
        return [
            ("test_validation", test_validation),
        ]
    }
}
