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
}
