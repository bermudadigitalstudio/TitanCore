import XCTest
@testable import TitanCore

final class MiddlewareTests: XCTestCase {
    func testCanAddMiddleware() {
        Titan().middleware(middleware: { (req: RequestType, res: ResponseType) -> (RequestType, ResponseType) in
            print(req)
            print(res)
            return (Request("GET", ""), Response(-1, ""))
        })
    }

    func testMiddlewareIsCalled() {
    }

    static var allTests: [(String, (MiddlewareTests) -> () throws -> Void)] {
        return [
            ("testMiddlewareIsCalled", testMiddlewareIsCalled),
            ("testCanAddMiddleware", testCanAddMiddleware),
        ]
    }
}
