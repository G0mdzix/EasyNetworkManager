import Foundation

public enum NetworkError: Error {
  case networkFailure
  case badURL
  case badServerResponse
  case decodingError
  case unknownError

  public var description: String {
    switch self {
    case .networkFailure:
      return "Network failure occurred."
    case .badURL:
      return "The provided URL is invalid."
    case .badServerResponse:
      return "The server responded with an error."
    case .decodingError:
      return "Error occurred during decoding."
    case .unknownError:
      return "An unknown error occurred."
    }
  }
}
