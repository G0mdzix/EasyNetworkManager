import Foundation

// MARK: - Model

public struct EasyNetworkManagerRequestModel {
  public let urlString: String
  public let headers: [String: String]?
  public let body: Data?
  public let requestTimeOut: Float?
  public let httpMethod: HTTPMethod

  public init(
    urlString: String,
    headers: [String : String]? = nil,
    body: Data? = nil,
    requestTimeOut: Float? = nil,
    httpMethod: HTTPMethod
  ) {
    self.urlString = urlString
    self.headers = headers
    self.body = body
    self.requestTimeOut = requestTimeOut
    self.httpMethod = httpMethod
  }
}
