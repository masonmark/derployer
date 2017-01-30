// TargetHostValuesTests.swift Created by mason on 2017-01-25.

import XCTest
@testable import Derployer

class TargetHostValuesTests: XCTestCase {
    
    func test_basic() {
        
        let t  = TargetHostValues(hostname: "host.bro", username: "usernameBRO", sshPort: "666", sshKeyPath: "path.to.key")
        
        guard let t2 = TargetHostValues(json: t.JSON) else {
            XCTFail("serialization failed :-/")
            return
        }
        XCTAssertEqual(t2.hostname, "host.bro")
        XCTAssertEqual(t2.username, "usernameBRO")
        XCTAssertEqual(t2.sshPort, "666")
        XCTAssertEqual(t2.sshKeyPath, "path.to.key")
    }
}

extension TargetHostValuesTests {
    
    static var allTests : [(String, (TargetHostValuesTests) -> () throws -> Void)] {
        return [
            ("test_basic", test_basic),
        ]
    }
}
