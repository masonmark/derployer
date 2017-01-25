// Mason 2017-01-24: This file was created automatically when doing "swift test" (or maybe it was "swift build"?) on Linux, after first having developed the first few bits of code on macOS. Obviously, the neccessity for this file's existence, and the manual `allTests` computed property in each and every test case class, is unfortunate and annoying. But it is a well-known problem, and a fix is very probably coming at some point, so... we just have to deal with it, for now.

import XCTest
@testable import DerployerTests

XCTMain([
    testCase(DefaultMenuFormatterTests.allTests),
    testCase(DeployValuesTests.allTests),
    testCase(DerployerTests.allTests),
    testCase(MenuInterfaceTests.allTests),
    testCase(MenuTests.allTests),
    testCase(TaskWrapperTests.allTests),
    testCase(TargetHostValuesTests.allTests),
    testCase(SettingsTests.allTests),
    testCase(ValueListTests.allTests),
])
