import XCTest
@testable import Derployer

class DerployerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Derployer().text, "Hello, World!")
    }


    static var allTests : [(String, (DerployerTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
