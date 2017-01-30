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

    static var allTests: [(String, (FunctionTests) -> () throws -> Void)] {
        return [
            ("testCanAddFunction", testCanAddFunction),
        ]
    }
}
