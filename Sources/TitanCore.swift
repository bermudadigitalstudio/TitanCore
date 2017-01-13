/// Little known fact: HTTP headers need not be unique!
public typealias Header = (String, String)

public protocol RequestType {
    var body: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [Header] { get }
}

public protocol ResponseType {
    var body: String { get }
    /// Status code. We have deliberately eschewed a status line since HTTP/2 ignores it, rarely used.
    var code: Int { get }
    var headers: [Header] { get }
}

public struct Request {
    public let method: String
    public let path: String
    public let body: String
    public let headers: [Header]

    public init(_ method: String, _ path: String, _ body: String = "", headers: [Header] = []) {
        self.method = method
        self.path = path
        self.body = body
        self.headers = headers
    }
}

public struct Response {
    public let code: Int
    public let body: String
    public let headers: [Header]

    public init(_ code: Int, _ body: String, headers: [Header] = []) {
        self.code = code
        self.body = body
        self.headers = headers
    }
}

extension Response: ResponseType {}

extension Request: RequestType {}

public typealias Function = (RequestType, ResponseType) -> (RequestType, ResponseType)
public final class Titan {
    public init() {}
    private var functionStack = Array<Function>()

    /// add a function to Titan’s request, response processing flow
    public func addFunction(function: @escaping Function) {
        functionStack.append(function)
    }

    /// Titan app instance, should be given to a server
    public func app(request: RequestType) -> ResponseType {
        typealias Result = (RequestType, ResponseType)

        let initialReq = request
        let initialRes = Response(-1, "")
        let initial: Result = (initialReq, initialRes)
        let res = functionStack.reduce(initial) { (res, next) -> Result in
            return next(res.0, res.1)
        }
        return res.1
    }
}
