// MenuTests.swift Created by mason on 2017-01-20.

import XCTest
@testable import Derployer

class MenuTests: XCTestCase {
    
    func test_basic_presentation() {
        
        let face = TestMenuInterface()
        
        let menudo = Menu(title: "MENUDO")
        menudo.content = [
            MenuItem("foo", value: "bar"),
            MenuItem("baz", value: "ホゲ")
        ]
        menudo.interface = face
        
        menudo.run()
        
        let expected = [
            "=====  MENUDO  =============================================================================",
            "",
            "[1] foo: bar",
            "[2] baz: ホゲ",
            "",
            "Choose from menu, or press ↩︎ to accept current values:",
            "",
            ">"
        ].joined(separator: "\n")
        
        let actual = face.outputText
        
        XCTAssertEqual(actual, expected)
    }
}
