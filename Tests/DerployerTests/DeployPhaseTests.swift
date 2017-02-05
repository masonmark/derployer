// DeployPhaseTests Created by mason on 2017-01-27.

import XCTest
@testable import Derployer

class DeployPhaseTests: TestCase {

    let bool = MenuItem("a bool", value: "true", type: .boolean)
    
    let only = MenuItem("only certain values", value: "5", type: .predefined, predefinedValues: ["5", "🍜"])
    
    let any  = MenuItem("anything allowed", value: "5", predefinedValues: ["apple", "banana", "cherry"])
    

    
    func test_serialization() {
        
        let list = DeployPhase(menuItems: [bool, only, any])

        let url  = temporaryDirectoryURL().appendingPathComponent("test_serialization")
        
        list.write(url: url)

        guard let rehydrated = DeployPhase(url: url) else {
            XCTFail();
            return;
        }
        
        guard let uno = rehydrated.menuItems[safe: 0], let dos = rehydrated.menuItems[safe: 1], let tres = rehydrated.menuItems[safe: 2] else {
            XCTFail("wrong number of derp vals")
            return
        }
        
        XCTAssert(uno.name  == "a bool")
        XCTAssert(uno.value == "true")
        XCTAssert(uno.type  == .boolean)
        
        XCTAssert(dos.name  == "only certain values")
        XCTAssert(dos.value == "5")
        XCTAssert(dos.type  == .predefined)
        
        XCTAssert(tres.name  == "anything allowed")
        XCTAssert(tres.value == "5")
        XCTAssert(tres.type  == .string)
    }

    
    func test_Menu_init_with_DeployPhase() {
        
        let list = DeployPhase(menuItems: [bool, only, any])
        let mi   = TestMenuInterface(shouldPrint: true)
        let menu = Menu(deployPhase: list)
        menu.interface  = mi
        
        mi.inputs = [
            "1",     // should toggle the bool
            "2",     // should open menu for editing predefined value
            "2",     // should choose the second value (🍜)
            "3",     // should open menu for editing arbitrary value
            "∂erp!", // should become new value (since it is not one of the menu choices)
            ""       // should end the menu, so it returns its result
        ]
        

        // Mason 2017-02-03: There is no reason we need to got full round-trip yet.
        // Just have it return self.values for now at least.
        //        guard let actual = menu.run() as? DerpValList else {
        //            XCTFail("run() didn't return expected obj type")
        //            return
        //        }

        let actual = menu.run() as? [String:String];
        
        let expectedValues: [String:String] = [
            "a bool"  : "false",
            "only certain values"  : "🍜",
            "anything allowed" : "∂erp!"
        ]
        XCTAssertEqual(menu.values, expectedValues)
        
        // FIXME: compare objects
        print(actual)
    }
    
    
    
}


extension DeployPhaseTests {
    
    static var allTests : [(String, (DeployPhaseTests) -> () throws -> Void)] {
        return [
            ("test_serialization", test_serialization),
            ("test_Menu_init_with_DeployPhase", test_Menu_init_with_DeployPhase),
        ]
    }
}
