// MenuItemTests.swift Created by mason on 2017-01-31.

import XCTest
@testable import Derployer

class MenuItemTests: XCTestCase {
    
    let bool       = MenuItem("bool", value: true, type: .boolean)
    let string     = MenuItem("string", value: "hoge", type: .string)
    let string2    = MenuItem("español", value: "¿que?", type: .string, predefinedValues: ["uno", "dos", "tres"])
    let predefined = MenuItem("predefined", value: "foo", type: .predefined, predefinedValues: ["foo", "bar"])
    let interface  = TestMenuInterface()
    
    
    func test_init_from_string_MenuItem() {
        
        // NO: currently we don't have a menu for .boolean items (they do their own input processing) // let menu = Menu(menuItem: bool)
        
        let menu = Menu(menuItem: string, interface: interface)
        interface.inputs = [""]
        interface.shouldPrint = true
        let result1 = menu.run() as? String
        XCTAssertEqual(result1, "hoge")
        interface.inputs = ["#whackjobPOTUS"]
        let result2 = menu.run() as? String
        XCTAssertEqual(result2, "#whackjobPOTUS")
    }
    
    
    func test_init_from_string_MenuItem_with_predefined_values() {
        
        let menu = Menu(menuItem: string2, interface: interface)
        interface.shouldPrint = true

        var result: String?

        interface.inputs = [
            "4",   // select the 'other value' option
            "hola" // enter arbitrary value
        ]
        result = menu.run() as? String
        XCTAssertEqual(result, "hola")
        
        interface.inputs = ["1"]
        result = menu.run() as? String
        XCTAssertEqual(result, "uno")
        
        interface.inputs = ["3"]
        result = menu.run() as? String
        XCTAssertEqual(result, "tres")
    }
    
    
    func test_init_from_predefined_MenuItem() {
        
        let menu = Menu(menuItem: predefined, interface: interface)
        interface.shouldPrint = true

        var result: String?
        
        interface.inputs = ["1"]
        result = menu.run() as? String
        XCTAssertEqual(result, "foo")
        
        interface.inputs = ["2"]
        result = menu.run() as? String
        XCTAssertEqual(result, "bar")
        
        interface.inputs = ["1"]
        result = menu.run() as? String
        XCTAssertEqual(result, "foo")
        
        interface.inputs = [
            "3",     // invalid
            "∂erp!", // invalid
            "2"      // bar
        ]
        result = menu.run() as? String
        XCTAssertEqual(result, "bar")

        print(interface.outputs.joined(separator: "\n----WOOOOOOT:-----\n"))
    }


    
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
        
        _ = bool.run(interface: interface)
        XCTAssertEqual(bool.boolValue, false)
        // running a bool just flips the value
    }
    
    
    func test_run_string() {
        
        var interface = TestMenuInterface()
        interface.shouldPrint = true
        
        interface.inputs = ["gone is gone"]
        _ = string.run(interface: interface)
        var expected = [
            string.messageAcceptOrManuallyChangeValue(name: "string", value: "hoge"),
            string.messageValueChanged(name: "string", newValue: "gone is gone\n\n")
        ]
        XCTAssertEqual(interface.outputs, expected)
        
        interface = TestMenuInterface()
        _ = string.run(interface: interface)
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
