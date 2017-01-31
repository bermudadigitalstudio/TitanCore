import XCTest
@testable import TitanCore

final class FunctionTests: XCTestCase {

    func testCanAddFunction() {
        Titan().addFunction({ (req: RequestType, res: ResponseType) -> (RequestType, ResponseType) in
            print(req)
            print(res)
            var newReq = req.copy()
            newReq.headers.append(("hello", "world"))
            return (newReq, Response(code: -1, body: "", headers: []))
        })
    }

  func testFunctionsAreInvokedInOrder() {
    let t = Titan()
    var accumulator: [Int] = []
    t.addFunction {
      accumulator.append(0)
      return $0
    }

    t.addFunction {
      accumulator.append(1)
      return $0
    }
    t.addFunction {
      accumulator.append(2)
      return $0
    }
    t.addFunction {
      accumulator.append(3)
      return $0
    }
    _ = t.app(request: Request(method: "", path: "", body: "", headers: []))
    XCTAssertEqual(accumulator.count, 4)
    XCTAssertEqual(accumulator[3], 3)
  }

  func testFirstFunctionRegisteredReceivesRequest() {
    let t = Titan()
    var request: RequestType!
    t.addFunction { req, res in
      request = req
      return (req, res)
    }
    _ = t.app(request: Request(method: "METHOD", path: "/PATH", body: "body", headers: [("some-header", "some-value")]))
    XCTAssertEqual(request.body, "body")
    XCTAssertEqual(request.method, "METHOD")
    XCTAssertEqual(request.path, "/PATH")
    XCTAssertEqual(request.headers.first!.name, "some-header")
    XCTAssertEqual(request.headers.first!.value, "some-value")
  }

  func testResponseComesFromLastResponseReturned() {
    let t = Titan()
    t.addFunction { req, _ in
      return (req, Response(code: 100, body: "not this body", headers: [("content-type-WRONG", "application/json")]))
    }
    t.addFunction { req, _ in
      return (req, Response(code: 700, body: "response body", headers: [("content-type", "text/plain")]))
    }
    let response = t.app(request: Request(method: "", path: "", body: "", headers: []))
    XCTAssertEqual(response.body, "response body")
    XCTAssertEqual(response.code, 700)
    XCTAssertEqual(response.headers.first!.name, "content-type")
    XCTAssertEqual(response.headers.first!.value, "text/plain")
  }

  func testFunctionInputIsOutputOfPrecedingFunction() {
    let t = Titan()
    t.addFunction { _ in
      return (Request(method: "METHOD", path: "/PATH", body: "body", headers: [("some-header", "some-value")]), Response(code: 700, body: "response body", headers: [("content-type", "text/plain")]))
    }
    var request: RequestType!, response: ResponseType!
    t.addFunction { req, res in
      request = req
      response = res
      return (req, res)
    }

    _ = t.app(request: Request(method: "", path: "", body: "", headers: []))

    XCTAssertEqual(request.body, "body")
    XCTAssertEqual(request.method, "METHOD")
    XCTAssertEqual(request.path, "/PATH")
    XCTAssertEqual(request.headers.first!.name, "some-header")
    XCTAssertEqual(request.headers.first!.value, "some-value")

    XCTAssertEqual(response.body, "response body")
    XCTAssertEqual(response.code, 700)
    XCTAssertEqual(response.headers.first!.name, "content-type")
    XCTAssertEqual(response.headers.first!.value, "text/plain")
  }

    static var allTests: [(String, (FunctionTests) -> () throws -> Void)] {
        return [
            ("testCanAddFunction", testCanAddFunction),
            ("testFunctionsAreInvokedInOrder", testFunctionsAreInvokedInOrder),
            ("testFunctionInputIsOutputOfPrecedingFunction", testFunctionInputIsOutputOfPrecedingFunction),
            ("testResponseComesFromLastResponseReturned", testResponseComesFromLastResponseReturned),
            ("testFirstFunctionRegisteredReceivesRequest", testFirstFunctionRegisteredReceivesRequest),
        ]
    }
}
