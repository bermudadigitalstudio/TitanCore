public struct Request {
  public init(_ method: String, _ path: String, _ body: String = "") {
    self.method = method
    self.path = path
    self.body = body
  }
  public let method: String
  public let path: String
  public let body: String
}

public protocol RequestType {
  var body: String { get }
  var path: String { get }
  var method: String { get }
}

public protocol ResponseType {
  var body: String { get }
  var code: Int { get }
}

public struct Response {
  public let code: Int
  public let body: String

  public init(_ code: Int, _ body: String) {
    self.code = code
    self.body = body
  }
}

extension Response: ResponseType {}

extension Request: RequestType {}

public typealias Middleware = (RequestType, ResponseType) -> (RequestType, ResponseType)
public final class Titan {
  public init() {}
  private var middlewareStack = Array<Middleware>()
  public func middleware(middleware: @escaping Middleware) {
    middlewareStack.append(middleware)
  }
  public func app(request: RequestType) -> ResponseType {
    typealias Result = (RequestType, ResponseType)

    let initialReq = request
    let initialRes = Response(-1, "")
    let initial: Result = (initialReq, initialRes)
    let res = middlewareStack.reduce(initial) { (res, next) -> Result in
      return next(res.0, res.1)
    }
    return res.1
  }
}

