import Foundation

struct ParkingSpaceList: Codable {
  let features: [ParkingSpace]
}

struct ParkingSpace: Codable {
  let geometry: ParkingGeometry
  let properties: ParkingProperties
}

struct ParkingGeometry: Codable {
  let coordinates: [Double]
}

struct ParkingProperties: Codable {
  let bilon, blik, zone, street, karta, peka: String
}
