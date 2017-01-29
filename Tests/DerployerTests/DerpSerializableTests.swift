// DerpSerializableTests.swift Created by mason on 2017-01-29.

import XCTest
@testable import Derployer

import Mason

private final class 💩: DerpSerializable {
    
    var state = "happy"
    var color = "brown"
    
    var serializationValues: DerpSerializationValues {
        
        get {
            return ["state": state, "color": color]
        }
        set {
            state = newValue["state"] as? String ?? state
            color = newValue["color"] as? String ?? color
        }
    }
}


class DerpSerializableTests: TestCase  {
    
    private let obj = 💩()
    
    
    func test_JSONString() {
        
        let jsonString = obj.JSON
        XCTAssert(jsonString.contains("\"state\" : \"happy\""))
        XCTAssert(jsonString.contains("\"color\" : \"brown\""))
          // Weak test; we can't do a full string comparison because order of keys in JSON is undefined.
    }
    
    
    func test_to_from_file() {
     
        obj.state = "angry"
        obj.color = "green"
        
        let url = temporaryDirectoryURL().appendingPathComponent("test_to_from_file")
        
        obj.write(url: url)
        
        guard let obj2 = 💩(url: url) else {
            XCTFail("init from file URL failed")
            return;
        }
        
        XCTAssertEqual(obj2.state, "angry")
        XCTAssertEqual(obj2.color, "green")
    }
}


extension DerpSerializableTests {
    
    static var allTests : [(String, (DerpSerializableTests) -> () throws -> Void)] {
        return [
            ("test_JSONString", test_JSONString),
            ("test_to_from_file", test_to_from_file),
        ]
    }
}