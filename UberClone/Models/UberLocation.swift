//
//  UberLocation.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-09.
//

import CoreLocation

struct UberLocation: Identifiable {
    let id = UUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}
