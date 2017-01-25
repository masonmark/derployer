// SettingsTests.swift Created by mason on 2017-01-24.

import XCTest
@testable import Derployer

import Foundation // for NSString stuff


class SettingsTests: XCTestCase {
    
    override func setUp() {
        
        let savePath = "/tmp/com.masonmark.derployer.tests.Settings-Default-OutputDir"
        let result   = TaskWrapper.run("/bin/mkdir", arguments: ["-p", savePath])
        XCTAssertEqual(result.terminationStatus, 0)
        
        Settings.pathToDefaultPersistenceLocation = savePath
    }
    
    
    func test_Settings_serialization() {

        guard let settings = Settings(identifier: "com.masonmark.derployer") else {
            XCTFail();
            return
        }

        // this tests a roundtrip encode/decode, but without the actual write/read file part
        settings.targetHostValues = TargetHostValues(hostname: "hostname.bro", username: "username.bro", sshPort: "10022", sshKeyPath: "~/bro.rsa")
        settings.deployValues = DeployValues(values: [
            "uno"  : "one",
            "dos"  : "two",
            "west" : "coast",
            "FT"   : "W",
        ])
        
        let dehydrated   = settings.values
        let rehydrated   = Settings(values: dehydrated, identifier: settings.identifier)
        
        XCTAssertEqual(settings.JSON, rehydrated.JSON)
    }
    
    
    func test_Settings_read_and_write_file() {
        
        let uniqueIdentifier = "com.masonmark.derployer.tests.read-write-file-\(UUID().uuidString)"
        
        guard let settings = Settings(identifier: uniqueIdentifier) else {
            XCTFail();
            return
        }
        
        // Defaults come from TarggetHostValues.defaults:
        // hostname: , username: "ubuntu", sshPort: "22", sshKeyPath: "~/.ssh/path_to_key_file"

        XCTAssertEqual(settings.targetHostValues.hostname, "127.0.0.1")
        XCTAssertEqual(settings.targetHostValues.username, "ubuntu")
        XCTAssertEqual(settings.targetHostValues.sshKeyPath, "~/.ssh/path_to_key_file")
        XCTAssertEqual(settings.targetHostValues.sshPort, "22")
        
        
        settings.targetHostValues.hostname   = "host1.bro"
        settings.targetHostValues.username   = "user1.bro"
        settings.targetHostValues.sshKeyPath = "/home/bro/ssh_key1"
        settings.targetHostValues.sshPort    = "5022"
        
        settings.deployValues["beer"] = "no thanks"
        settings.deployValues["brussels sprouts"] = "oh yes please"
        
        settings.write()
        
        guard let settings2 = Settings(identifier: uniqueIdentifier) else {
            XCTFail();
            return
        }

        XCTAssertEqual(settings2.targetHostValues.hostname, "host1.bro")
        XCTAssertEqual(settings2.targetHostValues.username, "user1.bro")
        XCTAssertEqual(settings2.targetHostValues.sshKeyPath, "/home/bro/ssh_key1")
        XCTAssertEqual(settings2.targetHostValues.sshPort, "5022")
        
        XCTAssertEqual(settings2.deployValues["beer"] as? String, "no thanks")
        XCTAssertEqual(settings2.deployValues["brussels sprouts"] as? String, "oh yes please")
    }
    
    
    func test_settingsPath() {
        guard let settings = Settings(identifier: "com.masonmark.derployer") else {
            XCTFail();
            return
        }

        let path = NSString(string: settings.settingsPath)
        XCTAssert(path.contains(settings.identifier))
    }
}


extension SettingsTests {
    
    static var allTests : [(String, (SettingsTests) -> () throws -> Void)] {
        return [
            ("test_Settings_serialization", test_Settings_serialization),
            ("test_Settings_read_and_write_file", test_Settings_read_and_write_file),
            ("test_settingsPath", test_settingsPath),
        ]
    }
}
