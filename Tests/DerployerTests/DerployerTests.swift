import XCTest
@testable import Derployer

import Foundation // for NSString stuff

class DerployerTests: XCTestCase {
    
    override func setUp() {
        Derployer.pathToDefaultPersistenceLocation = "/tmp/derployer-tests/DerployerTests"
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(Derployer())
    }
    
    func test_confirmTargetHostValues_saves_its_values() {
        
        Derployer.pathToDefaultPersistenceLocation = "/tmp/derployer-tests/DerployerTests-\(UUID().uuidString)"
          // Make one-off unique path for this test execution only.

        let testVal = "value modified by test WHOO!"
        
        let d = Derployer(identifier: "test_confirmTargetHostValues")
        d.menuInterface = TestMenuInterface(inputs: ["1", testVal, ""], shouldPrint: true)
        d.confirmTargetHostValues()
        
        let d2 = Derployer(identifier: "test_confirmTargetHostValues")
        let mi2 = TestMenuInterface()
        d2.menuInterface = mi2
        d2.confirmTargetHostValues()
        
        print(mi2.outputs)
        
        XCTAssert(mi2.outputs.joined().contains(testVal))
    }
    
    
    
//    func test_Settings_serialization() {
//        
//        guard let settings = Settings(identifier: "com.masonmark.derployer") else {
//            XCTFail();
//            return
//        }
//        
//        // this tests a roundtrip encode/decode, but without the actual write/read file part
//        settings.targetHostValues = TargetHostValues(hostname: "hostname.bro", username: "username.bro", sshPort: "10022", sshKeyPath: "~/bro.rsa")
//        settings.deployValues = DerpValList(values: [
//            DerpVal(
//            "uno"  : "one",
//            "dos"  : "two",
//            "west" : "coast",
//            "FT"   : "W",
//            ])
//        
//        let dehydrated   = settings.values
//        let rehydrated   = Settings(values: dehydrated, identifier: settings.identifier)
//        
//        XCTAssertEqual(settings.JSON, rehydrated.JSON)
//    }
//    
//    
//    func test_Settings_read_and_write_file() {
//        
//        let uniqueIdentifier = "com.masonmark.derployer.tests.read-write-file-\(UUID().uuidString)"
//        
//        guard let settings = Settings(identifier: uniqueIdentifier) else {
//            XCTFail();
//            return
//        }
//        
//        // Defaults come from TarggetHostValues.defaults:
//        // hostname: , username: "ubuntu", sshPort: "22", sshKeyPath: "~/.ssh/path_to_key_file"
//        
//        XCTAssertEqual(settings.targetHostValues.hostname, "127.0.0.1")
//        XCTAssertEqual(settings.targetHostValues.username, "ubuntu")
//        XCTAssertEqual(settings.targetHostValues.sshKeyPath, "~/.ssh/path_to_key_file")
//        XCTAssertEqual(settings.targetHostValues.sshPort, "22")
//        
//        
//        settings.targetHostValues.hostname   = "host1.bro"
//        settings.targetHostValues.username   = "user1.bro"
//        settings.targetHostValues.sshKeyPath = "/home/bro/ssh_key1"
//        settings.targetHostValues.sshPort    = "5022"
//        
//        settings.deployValues["beer"] = "no thanks"
//        settings.deployValues["brussels sprouts"] = "oh yes please"
//        
//        settings.write()
//        
//        guard let settings2 = Settings(identifier: uniqueIdentifier) else {
//            XCTFail();
//            return
//        }
//        
//        XCTAssertEqual(settings2.targetHostValues.hostname, "host1.bro")
//        XCTAssertEqual(settings2.targetHostValues.username, "user1.bro")
//        XCTAssertEqual(settings2.targetHostValues.sshKeyPath, "/home/bro/ssh_key1")
//        XCTAssertEqual(settings2.targetHostValues.sshPort, "5022")
//        
//        XCTAssertEqual(settings2.deployValues["beer"] as? String, "no thanks")
//        XCTAssertEqual(settings2.deployValues["brussels sprouts"] as? String, "oh yes please")
//    }
    

}


extension DerployerTests {

    static var allTests : [(String, (DerployerTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
            ("test_confirmTargetHostValues_saves_its_values", test_confirmTargetHostValues_saves_its_values),
//            ("test_Settings_serialization", test_Settings_serialization),
//            ("test_Settings_read_and_write_file", test_Settings_read_and_write_file),
        ]
    }
}
