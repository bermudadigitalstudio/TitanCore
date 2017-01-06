import XCTest
@testable import titan_core

class titan_coreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(titan_core().text, "Hello, World!")
    }


    static var allTests : [(String, (titan_coreTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
