// TargetHostValuesTests.swift Created by mason on 2017-01-25.

import XCTest
@testable import Derployer

class TargetHostValuesTest: XCTestCase {
    
    func test_basic() {
        
        let t  = TargetHostValues(hostname: "host.bro", username: "usernameBRO", sshPort: "666", sshKeyPath: "path.to.key")
        
        guard var t2 = TargetHostValues(json: t.JSON) else {
            XCTFail("serialization failed :-/")
            return
        }
        XCTAssertEqual(t2.hostname, "host.bro")
        XCTAssertEqual(t2.username, "usernameBRO")
        XCTAssertEqual(t2.sshPort, "666")
        XCTAssertEqual(t2.sshKeyPath, "path.to.key")
        
        t2["hostname"] = "new.hostname"
        XCTAssertEqual(t2.hostname, "new.hostname")
        t2.username = "new user name bro"
        XCTAssertEqual(t2["username"] as? String, "new user name bro")
    }
}
