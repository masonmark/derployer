// MenuTests.swift Created by mason on 2017-01-20.

import XCTest
@testable import Derployer

import Foundation // for String's hasPrefix() and contains()

class MenuTests: XCTestCase {
    
    let menu          = Menu(title: "TEST MENU")
    let menuInterface = TestMenuInterface()

    func test_basic_presentation() {
        
        menu.content = [
            MenuItem("foo", value: "bar"),
            MenuItem("baz", value: "ホゲ")
        ]
        menu.interface = menuInterface
        
        menu.run()
        
        let expected = [
            "=====  TEST MENU  ==========================================================================",
            "",
            "[1] foo: bar",
            "[2] baz: ホゲ",
            "",
            "Choose from menu, or press ↩︎ to accept current values:",
            "",
            ">"
        ].joined(separator: "\n")
        
        let actual = menuInterface.outputText
        
        XCTAssert(actual.hasPrefix(expected))
    }
    
    
    func test_edit_values() {
        
        menuInterface.inputs = ["1", "#assclownPOTUS", "2", "💩"]
        
        test_basic_presentation()
        
        let expected = [
            "=====  TEST MENU  ==========================================================================",
            "",
            "[1] foo: #assclownPOTUS",
            "[2] baz: 💩",
            "",
            "Choose from menu, or press ↩︎ to accept current values:",
            "",
            ">"
        ].joined(separator: "\n")        
        
        XCTAssert(menuInterface.outputText.contains(expected), "menu didn't display edited values ")
    }
    
    func test_manage_values() {
        
        test_edit_values()
        
        let expected = [
            "foo" : "#assclownPOTUS",
            "baz" : "💩"
        ]
        
        XCTAssertEqual(expected, menu.values())
        
    }
    
    func test_subscript() {
        
        menu.content = [
            MenuItem("foo", value: "bar"),
            MenuItem("baz", value: "ホゲ")
        ]
        XCTAssertEqual(menu["1"]?.value, "bar")
        XCTAssertEqual(menu["2"]?.value, "ホゲ")
        XCTAssertNil(menu["nonexistent"])
        XCTAssertNil(menu["666"])
        
        //        XCTAssertEqual(menu["foo"]?.value, "bar")
        //        XCTAssertEqual(menu["baz"]?.value, "ホゲ")
        // The above might (?) be a cool form to add someday...

    }
    
    /// This test can't easily be automated. Uncomment to try it manually:
    func test_manual() {
    //        menu.content = [
    //            MenuItem("foo", value: "bar"),
    //            MenuItem("baz", value: "ホゲ"),
    //            MenuItem("Roscoe _ Coltrain", value: "P.")
    //        ]
    //        menu.interface = DefaultMenuInterface()
    //        menu.run()
    //        print(menu.values())
    }
    
    func test_init_from_DeployValues() {
        let deployValues = DeployValues(values: ["foo" : "bar", "hoge" : "hoge"])
        let menu = Menu(deployValues: deployValues)
        
        XCTAssert(menu.content.count == 2);
    }

}


extension MenuTests {
    
    static var allTests : [(String, (MenuTests) -> () throws -> Void)] {
        return [
            ("test_basic_presentation", test_basic_presentation),
            ("test_edit_values", test_edit_values),
            ("test_manage_values", test_manage_values),
            ("test_subscript", test_subscript),
            ("test_manual", test_manual),
            ("test_init_from_DeployValues", test_init_from_DeployValues)
        ]
    }
}
