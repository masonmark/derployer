// DeployPhaseTests Created by mason on 2017-01-27.

import XCTest
@testable import Derployer

class DeployPhaseTests: TestCase {

    let bool = MenuItem("a bool", value: true, type: .boolean)
    
    let only = MenuItem("only certain values", value: "5", type: .predefined, predefinedValues: ["5", "🍜"])
    
    let any  = MenuItem("anything allowed", value: "5", predefinedValues: ["apple", "banana", "cherry"])
    
    let any2 = MenuItem("anything allowed 2", value: "5", predefinedValues: ["apple", "banana", "cherry"])
    

    
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
        
        XCTAssert(uno.name        == "a bool")
        XCTAssert(uno.stringValue == "true")
        XCTAssert(uno.boolValue   == true)
        XCTAssert(uno.type        == .boolean)
        
        XCTAssert(dos.name        == "only certain values")
        XCTAssert(dos.stringValue == "5")
        XCTAssert(dos.type        == .predefined)
        
        XCTAssert(tres.name        == "anything allowed")
        XCTAssert(tres.stringValue == "5")
        XCTAssert(tres.type        == .string)
    }

    
    func test_Menu_init_with_DeployPhase() {
        
        // a sort of E2E test for the menu components
        
        let list = DeployPhase(menuItems: [bool, only, any, any2])
        let mi   = TestMenuInterface(shouldPrint: true)
        let menu = Menu(list: list)
        
        menu.interface = mi
        
        mi.inputs = [
            "1",     // should toggle the bool to false
            "2",     // should open menu for editing predefined value
            "2",     // should choose the second value (🍜)
            "3",     // should open menu for editing arbitrary value
            "∂erp!", // should become new value (since it is not one of the menu choices)
            "4",     // choose 4th value
            "2",     // choose 2nd predefined item ("banana")
            ""       // should end the menu, so it returns its result
        ]
        
        guard let actual = menu.run() as? DeployPhase else {
            XCTFail("bad return type from run()")
            return
        }
        
        let shouldBeFalse  = actual["a bool"]?.boolValue
        let shouldBeRamen  = actual["only certain values"]?.stringValue
        let shouldBeDerp   = actual["anything allowed"]?.stringValue
        let shouldBeBanana = actual["anything allowed 2"]?.stringValue
        XCTAssertEqual(shouldBeFalse, false)
        XCTAssertEqual(shouldBeRamen, "🍜" )
        XCTAssertEqual(shouldBeDerp, "∂erp!" )
        XCTAssertEqual(shouldBeBanana, "banana" )
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
