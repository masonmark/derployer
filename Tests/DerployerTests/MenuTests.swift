// MenuTests.swift Created by mason on 2017-01-20.

import XCTest
@testable import Derployer

import Foundation // for String's hasPrefix() and contains()

class MenuTests: XCTestCase {
    
    let menu          = Menu(title: "TEST MENU")
    let menuInterface = TestMenuInterface(shouldPrint: true)
    
    
    override func setUp() {
        
        super.setUp()
        menu.interface = menuInterface
    }

    //    func test_fuck_Mason_your_initial_design_was_WRONG() {
    //        
    //        menu.content = [
    //            MenuItem("no", value: false),       // .boolean
    //            MenuItem("yes", value: 5),          // .integer
    //            MenuItem("name", value: "Roger"),   // .string
    //            MenuItem("drinks", predefinedValues: ["coffee", "tea", "milk"]), // .predefined
    //            
    //        ]
    //        
    //        
    //        
    //    }
    // MASON 2017-02-07: someday I want to change my design mistake where MenuItem's value is String....
    
        
    func test_basic_presentation() {
        
        menu.content = [
            MenuItem("foo", value: "bar"),
            MenuItem("baz", value: "ホゲ")
        ]
        menu.interface = menuInterface
        
        _ = menu.run()
        
        let expected = [
            "=====  TEST MENU  ==========================================================================",
            "",
            "[1]   foo: bar",
            "[2]   baz: ホゲ",
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
        menuInterface.shouldPrint = true
        
        test_basic_presentation()
        
        let expected = [
            "=====  TEST MENU  ==========================================================================",
            "",
            "[1]   foo: #assclownPOTUS",
            "[2]   baz: 💩",
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
        
        XCTAssertEqual(expected, menu.values)
        
    }
    
    func test_subscript() {
        
        menu.content = [
            MenuItem("foo", value: "bar"),
            MenuItem("baz", value: "ホゲ")
        ]
        XCTAssertEqual(menu["1"]?.stringValue, "bar")
        XCTAssertEqual(menu["2"]?.stringValue, "ホゲ")
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
    
    
    func test_custom_menu_values() {
        
        menuInterface.inputs = ["ho ho ho", "yee haw", "snausages!", "fuck Trump" ]
        
        var i = 0;
        
        menu.inputHandler = {
            
            input, menu in
            
            i += 1
            
            if input == "snausages!" {
                return "SUCCESS BRO"
            } else {
                menu.interface.writeResultsMessage("Sorry, '\(input)' is not what we're looking for.")
                return menu.run()
            }
        }
        let result = menu.run()
        XCTAssert(result as? String == "SUCCESS BRO")
        XCTAssertEqual(i, 3)
    }
    
    
    func test_init_from_DeployValues() {
        
        let values = [
            MenuItem("foo", value: "bar"),
            MenuItem("hoge", value: "hoge"),
        ]
        let phase = DeployPhase(menuItems: values)
        
        let menu = Menu(deployPhase: phase)
        
        XCTAssert(menu.content.count == 2);
        XCTAssert(menu.content[safe: 0]?.stringValue == "bar");
        XCTAssert(menu.content[safe: 1]?.stringValue == "hoge");
        
        menu.interface = TestMenuInterface(inputs: ["1", "ass", "2", "hat", ""])
        guard let result = menu.run() as? [String:String]  else {
            // no custom return type for this case
            XCTFail("bad return value type");
            return;
        }
        print(result)
        
        XCTAssert(result["foo"]  == "ass")
        XCTAssert(result["hoge"] == "hat")
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
