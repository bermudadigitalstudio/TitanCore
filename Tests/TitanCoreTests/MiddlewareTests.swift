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
        let expMutation = expectation(description: "mutates req & res")

        titan.middleware({ (req: inout RequestType, res: inout ResponseType) -> (RequestType, ResponseType) in
            XCTAssertEqual(req.path, "")
            XCTAssertEqual(res.body, "")
            req.path = expectedPath
            res.body = expectedBody
            // should fail as evidence that XCTest 
            // makes it actually in here
            XCTAssertEqual(1, 2)
            
            expMutation.fulfill() // does not seem to work
            return (req, res)
        })
        waitForExpectations(timeout: 5, handler: nil)

        // are res and req properties still set?
        let expStillSet = expectation(description: "req & res are still set")

        titan.middleware({ (req: inout RequestType, res: inout ResponseType) -> (RequestType, ResponseType) in
            XCTAssertEqual(req.path, expectedPath)
            XCTAssertEqual(res.body, expectedBody)
            expStillSet.fulfill()
            return (req, res)
        })
        waitForExpectations(timeout: 5, handler: nil)
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
