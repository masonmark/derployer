// MenuItemTests.swift Created by mason on 2017-01-31. 

import XCTest
@testable import Derployer

class MenuItemTests: XCTestCase {
    
    let bool       = MenuItem("bool", value: "true", validator: nil, type: .boolean)
    let string     = MenuItem("string", value: "hoge", validator: nil, type: .string)
    let predefined = MenuItem("predefined", value: "foo", validator: nil, type: .string, predefinedValues: ["foo", "bar"])
    
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
    
    func test_formatting() {
        
        XCTAssertEqual(bool.description, "✓ bool")
        XCTAssertEqual(string.description, "  string: hoge")
        XCTAssertEqual(predefined.description, "  predefined: foo")
        
        bool.value = "false"
        string.value = "j_vattrs"
        predefined.value = "bar"
        
        XCTAssertEqual(bool.description, "  bool")
        XCTAssertEqual(string.description, "  string: j_vattrs")
        XCTAssertEqual(predefined.description, "  predefined: bar")
    }
}


extension MenuItemTests {
    
    static var allTests : [(String, (MenuItemTests) -> () throws -> Void)] {
        return [
            ("test_validation", test_validation),
        ]
    }
}
