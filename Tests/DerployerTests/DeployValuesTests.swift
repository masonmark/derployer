// DeployValuesTests.swift Created by mason on 2017-01-25.

import XCTest
@testable import Derployer

class DeployValuesTests: XCTestCase {
    
    func test_basic() {
        
        let values = [
            "foo" : "bar",
            "new" : "car",
        ]
        
        let original  = DeployValues(values: values)
        
        guard let clone = DeployValues(json: original.JSON) else {
            XCTFail("serialization failed :-/")
            return
        }
        XCTAssertEqual(clone.JSON, original.JSON)
        
        XCTAssertEqual(clone["foo"] as? String, "bar")
        XCTAssertEqual(clone["new"] as? String, "car")
    }
}


extension DeployValuesTests {
    
    static var allTests : [(String, (DeployValuesTests) -> () throws -> Void)] {
        return [
            ("test_basic", test_basic),
        ]
    }
}
