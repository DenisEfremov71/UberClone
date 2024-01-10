//
//  GeoPoint+Extensions.swift
//  UberClone
//
//  Created by Denis Efremov on 2024-01-10.
//

import Firebase
import CoreLocation

extension GeoPoint {
    func toCoordinate() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
