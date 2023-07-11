import Combine
import Foundation

public class EasyNetworkManager {

  // MARK: - Singleton

  public static let shared = EasyNetworkManager()

  // MARK: - Lifecycle

  public init () {}

  // MARK: - Public function

  public func fetchData<T: Decodable>(
    dataModel: T.Type,
    requestModel: EasyNetworkManagerRequestModel
  ) -> AnyPublisher<EasyNetworkManagerResult<T>, NetworkError> {
    guard let sourceURL = URL(string: requestModel.urlString) else {
      return createURLErrorPublisher()
    }

    let request = getURLRequest(requestModel: requestModel, url: sourceURL)

    return performDataTask(with: request)
      .eraseToAnyPublisher()
  }
}

// MARK: - private functions

private extension EasyNetworkManager {
  private func performDataTask<T: Decodable>(
    with request: URLRequest
  ) -> AnyPublisher<EasyNetworkManagerResult<T>, NetworkError> {
    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        try self.validateResponse(response)
        return data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .map { EasyNetworkManagerResult.success($0) }
      .mapError { error -> NetworkError in
        return self.errorMapping(error)
      }
      .eraseToAnyPublisher()
  }

  private func getURLRequest(requestModel: EasyNetworkManagerRequestModel, url: URL) -> URLRequest {
    var baseUrlRequest = URLRequest(url: url)
    baseUrlRequest.httpMethod = requestModel.httpMethod.rawValue
    baseUrlRequest.allHTTPHeaderFields = requestModel.headers
    baseUrlRequest.httpBody = requestModel.body
    guard let time = requestModel.requestTimeOut else { return baseUrlRequest }
    baseUrlRequest.timeoutInterval = TimeInterval(time)
    return baseUrlRequest
  }

  private func validateResponse(_ response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.badServerResponse
    }
    guard (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.badServerResponse
    }
  }

  private func createURLErrorPublisher<T>()
  -> AnyPublisher<EasyNetworkManagerResult<T>, NetworkError> {
    return Fail(error: NetworkError.badURL)
      .map { EasyNetworkManagerResult.failure(error: $0) }
      .eraseToAnyPublisher()
  }

  private func errorMapping(_ error: Error) -> NetworkError {
    switch error {
    case is DecodingError:
      return NetworkError.decodingError
    case is URLError:
      return NetworkError.networkFailure
    default:
      return NetworkError.unknownError
    }
  }
}
