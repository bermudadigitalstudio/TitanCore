import XCTest
@testable import TitanCore

final class FunctionTests: XCTestCase {

    func testCanAddFunction() {
        Titan().addFunction(function: { (req: RequestType, res: ResponseType) -> (RequestType, ResponseType) in
            print(req)
            print(res)
            return (Request("GET", ""), Response(-1, ""))
        })
    }

    func testFunctionIsCalled() {
    }

    static var allTests: [(String, (FunctionTests) -> () throws -> Void)] {
        return [
            ("testFunctionIsCalled", testFunctionIsCalled),
            ("testCanAddFunction", testCanAddFunction),
        ]
    }
}
