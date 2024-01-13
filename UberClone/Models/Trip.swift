//
//  Trip.swift
//  UberClone
//
//  Created by Denis Efremov on 2024-01-05.
//

import Firebase
import FirebaseFirestoreSwift

enum TripState: Int, Codable {
    case requested
    case rejected
    case accepted
}

struct Trip: Identifiable, Codable {
    @DocumentID var tripId: String?
    let passengerUid: String
    let driverUid: String
    let passengerName: String
    let driverName: String
    let passengerLocation: GeoPoint
    let driverLocation: GeoPoint
    let pickupLocationName: String
    let dropoffLocationName: String
    let pickupLocationAddress: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let tripCost: Double
    var distanceToPassenger: Double
    var travelTimeToPassenger: Int
    var state: TripState

    var id: String {
        tripId ?? ""
    }
}
