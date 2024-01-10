//
//  Trip+Extensions.swift
//  UberClone
//
//  Created by Denis Efremov on 2024-01-10.
//

import SwiftUI
import Firebase

extension Trip {
    static var mockTrip: Trip {
        Trip(
            id: UUID().uuidString,
            passengerUid: UUID().uuidString,
            driverUid: UUID().uuidString,
            passengerName: "John Doe",
            driverName: "Adam Smith",
            passengerLocation: GeoPoint(latitude: 49.274474, longitude: -123.120360),
            driverLocation: GeoPoint(latitude: 49.281261, longitude: -123.122007),
            pickupLocationName: "Cocoa Tanning Studio",
            dropoffLocationName: "Metrotown",
            pickupLocationAddress: "1165 Pacific Blvd",
            pickupLocation: GeoPoint(latitude: 49.274474, longitude: -123.120360),
            dropoffLocation: GeoPoint(latitude: 49.227895, longitude: -123.000141),
            tripCost: 55.00
        )
    }
}
