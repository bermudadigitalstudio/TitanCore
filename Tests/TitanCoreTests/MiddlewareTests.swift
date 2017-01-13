import XCTest
@testable import TitanCore

final class MiddlewareTests: XCTestCase {
    func testCanAddMiddleware() {
        Titan().middleware({ (req: inout RequestType, res: inout ResponseType) -> (RequestType, ResponseType) in
            print(req)
            print(res)
            return (Request("GET", ""), Response(-1, ""))
        })
    }

    func testCanMutateRequestResponse() {
        let titan = Titan()
        let expectedPath = "foo"
        let expectedBody = "bar"

        // set some req and res properties
        titan.middleware({ (req: inout RequestType, res: inout ResponseType) -> (RequestType, ResponseType) in
            XCTAssertEqual(req.path, "")
            XCTAssertEqual(res.body, "")
            req.path = expectedPath
            res.body = expectedBody
            return (req, res)
        })

        // are res and req properties still set?
        titan.middleware({ (req: inout RequestType, res: inout ResponseType) -> (RequestType, ResponseType) in
            XCTAssertEqual(req.path, expectedPath)
            XCTAssertEqual(res.body, expectedBody)
            return (req, res)
        })
    }

    func testMiddlewareIsCalled() {
    }

    static var allTests: [(String, (MiddlewareTests) -> () throws -> Void)] {
        return [
            ("testMiddlewareIsCalled", testMiddlewareIsCalled),
            ("testCanAddMiddleware", testCanAddMiddleware),
            ("testCanMutateRequestResponse", testCanMutateRequestResponse),
        ]
    }
}
