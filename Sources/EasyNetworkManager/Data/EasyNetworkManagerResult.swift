import Foundation

public enum EasyNetworkManagerResult<T> {
  case success(T)
  case failure(error: Error)
}
