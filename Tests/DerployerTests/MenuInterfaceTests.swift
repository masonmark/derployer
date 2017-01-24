// MenuInterfaceTests.swift Created by mason on 2017-01-20. 

import XCTest
@testable import Derployer

class MenuInterfaceTests: XCTestCase {
    
    func test_TestMenuInterface() {
        let mi = TestMenuInterface()
        mi.inputs = ["foo", "bar"]
        
        XCTAssertEqual(mi.read(), "foo")
        XCTAssertEqual(mi.read(), "bar")

        mi.write("f")
        mi.write("you")
        
        XCTAssertEqual(mi.outputText, "fyou")
    }
    
    /// This test can't easily be automated. Uncomment to try it manually:
    func test_DefaultMenuInterface() {
    //            let mi = DefaultMenuInterface()
    //            mi.write("hello")
    //            let reply = mi.read()
    //            XCTAssertEqual(reply, "hi");
    }
}


extension MenuInterfaceTests {
    
    static var allTests : [(String, (MenuInterfaceTests) -> () throws -> Void)] {
        return [
            ("test_TestMenuInterface", MenuInterfaceTests.test_TestMenuInterface),
            ("test_DefaultMenuInterface", MenuInterfaceTests.test_DefaultMenuInterface),
        ]
    }
}
