import XCTest
@testable import DSAccounting

final class DSAccountingTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DSAccounting().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
