// ValueListTests.swift Created by mason on 2017-01-25.

// SettingsTests.swift Created by mason on 2017-01-24.

import XCTest
@testable import Derployer

import Foundation // for NSString stuff


class ValueListTests: XCTestCase {
    
    let complexValues = [
        "ass"     : "hat",
        "Tronald" : "Dump",
        "💩💩💩" : "🌶🌶🌶",
        "666"     : "OK, OK, {} we get it…"
    ]
    
    var settings = Settings(identifier: "com.masonmark.derployer");
    
    
    func test_ValueList_serialization() {
        // the empty object just encodes to "{}" (effectively, although it might be pretty-printed)
        let basic     = SimpleValueList()
        let encoded   = basic.JSON
        let decoded   = SimpleValueList(json: encoded)
        let reencoded = decoded?.JSON ?? "NOPE BRO"
        XCTAssertEqual(encoded, reencoded)
    }
    
    
    func test_ValueList_serialization_2() {
        
        
        let complex   = SimpleValueList(values: complexValues)
        let encoded   = complex.JSON;
        let decoded   = SimpleValueList(json: encoded)
        let reencoded = decoded?.JSON ?? "NOPE BRO"
        
        XCTAssertEqual(encoded, reencoded)
        
        guard let redecoded = SimpleValueList(json: reencoded) else {
            XCTFail("nil redecoded! T_T")
            return
        }
        
        XCTAssert(redecoded.values["ass"] as? String ==  "hat")
        XCTAssert(redecoded.values["Tronald"] as? String ==  "Dump")
        XCTAssert(redecoded.values["💩💩💩"] as? String == "🌶🌶🌶")
        XCTAssert(redecoded.values["666"] as? String == "OK, OK, {} we get it…")
    }
    
    
    func test_read_write_file() {
        
        let filePath = "/tmp/TEST-test_read_write_file-\(UUID().uuidString)"
        let list     = SimpleValueList(values: complexValues)
        list.write(path: filePath)
        
        guard let list2 = SimpleValueList(path: filePath) else {
            XCTFail("nil redecoded! T_T")
            return
        }
       
        XCTAssertEqual(list2.JSON, list.JSON)
        XCTAssertEqual(list2["ass"] as? String, "hat")
    }
    
    
    func test_tilde_expansion_on_Linux() {
        // Just making sure this works on Linux, too...
        
        let abbreviated = "~/foo" as NSString
        let expanded    = abbreviated.expandingTildeInPath
        XCTAssert(expanded.hasPrefix("/"))
        XCTAssert(expanded.hasSuffix("/foo"))
    }
    
    
    func test_tilde_expansion_on_Linux_jp() {
        
        let abbreviated = "~/foo" as NSString
        let expanded    = abbreviated.expandingTildeInPath
        XCTAssert(expanded.hasPrefix("/"))
        XCTAssert(expanded.hasSuffix("/foo"))
    }
}


extension ValueListTests {
    
    static var allTests : [(String, (ValueListTests) -> () throws -> Void)] {
        return [
            ("test_ValueList_serialization", test_ValueList_serialization),
            ("test_ValueList_serialization_2", test_ValueList_serialization_2),
            ("test_tilde_expansion_on_Linux", test_tilde_expansion_on_Linux),
            ("test_tilde_expansion_on_Linux_jp", test_tilde_expansion_on_Linux_jp),
        ]
    }
}
