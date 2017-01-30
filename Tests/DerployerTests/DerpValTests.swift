// DerpValTests.swift Created by mason on 2017-01-27.

import XCTest
@testable import Derployer

class DerpValTests: TestCase {

    let bool = DerpVal("a bool", type: .boolean, value: true)
    
    let only = DerpVal("only certain values", type: .predefined, value: "5", predefinedValues: ["5", "🍜"])
    
    let any  = DerpVal("anything allowed", value: "5", predefinedValues: ["apple", "banana", "cherry"])
    

    
    func test_simple_validation() {
    
        XCTAssertFalse(bool.validate("a string"))
        XCTAssertFalse(bool.validate(5))
        XCTAssertFalse(bool.validate(self))
        XCTAssertTrue(bool.validate(true))
        XCTAssertTrue(bool.validate(false))
        
        XCTAssertFalse(only.validate("6"))
        XCTAssertFalse(only.validate("spaghetti"))
        XCTAssertTrue(only.validate("5"))
        XCTAssertTrue(only.validate("🍜"))
    }
    
    
    func test_serialization() {
        
        let list = DerpValList([bool, only, any])

        let url  = temporaryDirectoryURL().appendingPathComponent("test_serialization")
        
        list.write(url: url)

        guard let rehydrated = DerpValList(url: url) else {
            XCTFail();
            return;
        }
        
        guard let uno = rehydrated.derpVals[safe: 0], let dos = rehydrated.derpVals[safe: 1], let tres = rehydrated.derpVals[safe: 2] else {
            XCTFail("wrong number of derp vals")
            return
        }
        
        XCTAssert(uno.identifier == "a bool")
        XCTAssert(uno.value as? Bool == true)
        XCTAssert(uno.type == .boolean)
        
        XCTAssert(dos.identifier == "only certain values")
        XCTAssert(dos.value as? String == "5")
        XCTAssert(dos.type == .predefined)
        
        XCTAssert(tres.identifier == "anything allowed")
        XCTAssert(tres.value as? String == "5")
        XCTAssert(tres.type == .string)
    }
    
    
    func test_Menu_init_with_DerpValList() {

        let list = DerpValList([bool, only, any])

        let menu = Menu(list: list)
       // menu.run()
    }
    
    
}


extension DerpValTests {
    
    static var allTests : [(String, (DerpValTests) -> () throws -> Void)] {
        return [
            ("test_simple_validation", test_simple_validation),
            ("test_serialization", test_serialization),
            ("test_Menu_init_with_DerpValList", test_Menu_init_with_DerpValList),
        ]
    }
}
