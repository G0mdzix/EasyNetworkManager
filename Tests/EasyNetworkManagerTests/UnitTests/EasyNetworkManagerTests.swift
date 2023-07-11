import XCTest
import Combine
@testable import EasyNetworkManager

class EasyNetworkManagerTests: XCTestCase {

  // MARK: - Properties (private)

  private var cancellables: Set<AnyCancellable>!

  private let networkManager = EasyNetworkManager.shared

  // MARK: - Lifecycle

  override func setUp() {
    super.setUp()
    cancellables = Set<AnyCancellable>()
  }

  override func tearDown() {
    cancellables = nil
    super.tearDown()
  }

  // MARK: - Tests

  func testFetchData_Success() {
    let expectation = XCTestExpectation(description: "Fetch data successful")

    let requestModel = EasyNetworkManagerRequestModel(
      urlString: "https://www.poznan.pl/mim/plan/map_service.html?mtype=pub_transport&co=parking_meters",
      httpMethod: .GET
    )

    networkManager.fetchData(dataModel: ParkingSpaceList.self, requestModel: requestModel)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case .failure(let error):
          XCTFail("Unexpected failure: \(error.description)")
        }
      }, receiveValue: { value in
        switch value {
        case .failure(let error):
          XCTFail("Unexpected failure result: \(error)")
        case .success(_):
          print("success")
        }
      })
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 30.0)
  }

  func testFetchData_Failure_BadURL() {
    let expectation = XCTestExpectation(description: "Fetch data unsuccessful")

    let requestModel = EasyNetworkManagerRequestModel(
      urlString: "https://google.tv",
      httpMethod: .GET
    )

    networkManager.fetchData(dataModel: ParkingSpaceList.self, requestModel: requestModel)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          XCTFail("Unexpected failure")
        case .failure(_):
          expectation.fulfill()
        }
      }, receiveValue: { value in
        switch value {
        case .failure(_):
          print("success")
        case .success(_):
          XCTFail("Unexpected failure")
        }
      })
      .store(in: &cancellables)

    wait(for: [expectation], timeout: 5.0)
  }
}
