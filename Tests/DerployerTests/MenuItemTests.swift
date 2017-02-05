// MenuItemTests.swift Created by mason on 2017-01-31. 

import XCTest
@testable import Derployer

class MenuItemTests: XCTestCase {
    
    let bool       = MenuItem("bool", value: "true", validator: nil, type: .boolean)
    let string     = MenuItem("string", value: "hoge", validator: nil, type: .string)
    let predefined = MenuItem("predefined", value: "foo", validator: nil, type: .predefined, predefinedValues: ["foo", "bar"])
    
    
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
    
    
    func test_validation_of_built_in_types() {
        
        XCTAssertTrue(bool.validate("true"))
        XCTAssertTrue(bool.validate("false"))
        XCTAssertFalse(bool.validate("hoge"))
        XCTAssertFalse(bool.validate("yes"))
        XCTAssertFalse(bool.validate("no"))
        XCTAssertFalse(bool.validate(""))
        
        XCTAssertTrue(predefined.validate("foo"))
        XCTAssertTrue(predefined.validate("bar"))
        XCTAssertFalse(predefined.validate("baz"))
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
    
    func test_run_boolean() {
        
        let interface = TestMenuInterface()
        interface.shouldPrint = true
        
        bool.run(interface: interface)
        XCTAssertEqual(bool.value, "false")
        // running a bool just flips the value
    }
    
    func test_run_string() {
        
        var interface = TestMenuInterface()
        interface.shouldPrint = true
        
        interface.inputs = ["gone is gone"]
        string.run(interface: interface)
        var expected = [
            string.messageAcceptOrManuallyChangeValue(name: "string", value: "hoge"),
            string.messageValueChanged(name: "string", newValue: "gone is gone")
        ]
        XCTAssertEqual(interface.outputs, expected)
        
        interface = TestMenuInterface()
        string.run(interface: interface)
        expected = [
            string.messageAcceptOrManuallyChangeValue(name: "string", value: "gone is gone"),
            string.messageNoChangeMade()
        ]
        XCTAssertEqual(interface.outputs, expected)
    }
}


extension MenuItemTests {
    
    static var allTests : [(String, (MenuItemTests) -> () throws -> Void)] {
        return [
            ("test_validation", test_validation),
        ]
    }
}
