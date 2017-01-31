// MenuFormatterTests.swift Created by mason on 2017-01-20.

import XCTest
@testable import Derployer

class TestMenuFormatter: MenuFormatter {
    
}

class MenuFormatterTests: XCTestCase {
    
    var formatter = TestMenuFormatter()
    
    func test_format_title() {
        
        var expected: String
        
        expected = "=====  FOO  ================================================================================\n\n"
        XCTAssertEqual(formatter.title("foo"), expected)
        
        expected = "=====  DOODIE MCSCROGGINS III, ESQ.  =======================================================\n\n"
        XCTAssertEqual(formatter.title("Doodie McScroggins III, Esq."), expected)
        
        expected = "=====  THE FREEDOM OF BIRDS IS AN INSULT TO ME. I'D HAVE THEM ALL IN ZOOS. THAT WOULD BE A HELL OF A ZOO.\n\n"
        XCTAssertEqual(formatter.title("The freedom of birds is an insult to me. I'd have them all in zoos. That would be a hell of a zoo."), expected)
        
    }
}


extension MenuFormatterTests {
    
    static var allTests : [(String, (MenuFormatterTests) -> () throws -> Void)] {
        return [
            ("test_format_title", MenuFormatterTests.test_format_title),
        ]
    }
}
