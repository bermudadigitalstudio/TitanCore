/// Little known fact: HTTP headers need not be unique!
public typealias Header = (name: String, value: String)

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
    public var method: String
    public var path: String
    public var body: String
    public var headers: [Header]

    public init(method: String, path: String, body: String, headers: [Header]) {
        self.method = method
        self.path = path
        self.body = body
        self.headers = headers
    }
}

public struct Response {
    public var code: Int
    public var body: String
    public var headers: [Header]

    public init(code: Int, body: String, headers: [Header]) {
        self.code = code
        self.body = body
        self.headers = headers
    }
}

extension Response: ResponseType {}
extension Request: RequestType {}

extension Response {
    public init(response: ResponseType) {
        self.init(code: response.code, body: response.body, headers: response.headers)
    }
}

extension Request {
    public init(request: RequestType) {
        self.init(method: request.method, path: request.path, body: request.body, headers: request.headers)
    }
}

extension ResponseType {
    public func copy() -> Response {
        return Response(response: self)
    }
}

extension RequestType {
    public func copy() -> Request {
        return Request(request: self)
    }
}

public typealias Function = (RequestType, ResponseType) -> (RequestType, ResponseType)
public final class Titan {
    public init() {}
    private var functionStack = Array<Function>()

    /// add a function to Titan’s request / response processing flow
    public func addFunction(_ function: @escaping Function) {
        functionStack.append(function)
    }

    /// Titan handler which should be given to a server
    public func app(request: RequestType) -> ResponseType {
        typealias Result = (RequestType, ResponseType)

        let initialReq = request
        let initialRes = Response(code: -1, body: "", headers: [])
        let initial: Result = (initialReq, initialRes)
        let res = functionStack.reduce(initial) { (res, next) -> Result in
            return next(res.0, res.1)
        }
        return res.1
    }
}
