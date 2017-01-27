// CoreUtilitiesTests.swift Created by mason on 2017-01-27. 

import XCTest
@testable import Derployer

class CoreUtilitiesTests: XCTestCase {
    
    func test_safe_subscript() {
    
        let foo = [0,1,2,3]
        XCTAssertEqual(foo[safe: 0], 0)
        XCTAssertEqual(foo[safe: 3], 3)
        XCTAssertNil(foo[safe: 4])
    }
}

extension CoreUtilitiesTests {
    
    static var allTests : [(String, (CoreUtilitiesTests) -> () throws -> Void)] {
        return [
            ("test_safe_subscript", test_safe_subscript),
        ]
    }
}
