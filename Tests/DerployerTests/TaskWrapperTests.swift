// TaskWrapperTests.swift Created by mason on 2017-01-24. 

import XCTest
@testable import Derployer

import Foundation

class TaskWrapperTests: XCTestCase {
    
    func test_basic() {
        let phrase = "the freedom of birds is an insult to me"
        let result = TaskWrapper.run("/bin/echo", arguments: [phrase])
        XCTAssertEqual(phrase + "\n", result.stdoutText)
    }
    
    
    func test_termination_status_capture() {
        let good = TaskWrapper("/bin/ls", arguments: ["/etc"])
        let bad  = TaskWrapper("/bin/ls", arguments: ["/hgghj/gfhjffjh/ghfghfhj/hgfghj"])
        
        good.launch()
        bad.launch()
        
        XCTAssert(good.stdoutData.count > 0)
        XCTAssert(good.stderrData.count == 0)
        XCTAssert(good.terminationStatus == 0)
        XCTAssert(bad.stdoutData.count == 0)
        XCTAssert(bad.stderrData.count > 0)
        XCTAssert(bad.terminationStatus != 0)
    }
    
    
    func test_fix_for_case_11_deadlock_with_large_output() {
        // Mason 2016-03-19: This is actually a test for the old NakaharaTask class (a massively more complex NSTask wrapper than TaskWrapper).
        
        // This was a regression test for a 2007 Obj-C bug (I think "Case 11" means we had just switched to Fogbugz and only had 11 bugs at that time?) involving filling up some buffers and deadlocking. Not sure how applicable it even is to this 2015 Swift version, but let's do it anyway.
        
        var testData   = Data()
        var testString = ""
        
        while testData.count < (1024 * 150) {
            let junk = "NAKAHARANAKAHARANAKAHARANAKAHARANAKAHARANAKAHARANAKAHARANAKAHARA"
            testData.append(junk.data(using: .utf8)!)
            testString += junk
        }
        
        let tmpPath = "/tmp/" + "testFixForCase11DeadlockWithLargeOutput-" + UUID().uuidString
        let tmpURL  = URL(fileURLWithPath: tmpPath)
        
        try? testData.write(to: tmpURL, options: [])
        
        let t = TaskWrapper("/bin/cat", arguments: [tmpPath], launch: false)
        t.launch()
        
        XCTAssert(t.terminationStatus == 0)
        
        let actualText   = t.stdoutText
        let expectedText = testString
        
        XCTAssert(actualText == expectedText)
        
        let actualData   = t.stdoutData
        let expectedData = testData
        
        XCTAssert(actualData == expectedData as Data)
    }
    
    
    func test_text_based_convenience_properties() {
        let ok = TaskWrapper.run("/bin/ls", arguments: ["/etc"])
        XCTAssert(ok.stdoutText != "")
        XCTAssert(ok.stderrText == "")
        XCTAssert(ok.terminationStatus == 0)
        
        let ng = TaskWrapper.run("/bin/ls", arguments: ["/nope/nope/jshdfdjk"])
        XCTAssert(ng.stdoutText == "")
        XCTAssert(ng.stderrText != "")
        XCTAssert(ng.terminationStatus != 0)
    }
}


extension TaskWrapperTests {
    
    static var allTests : [(String, (TaskWrapperTests) -> () throws -> Void)] {
        return [
            ("test_basic", test_basic),
            ("test_termination_status_capture", test_termination_status_capture),
            ("test_fix_for_case_11_deadlock_with_large_output", test_fix_for_case_11_deadlock_with_large_output),
            ("test_text_based_convenience_properties", test_text_based_convenience_properties),
        ]
    }
}
