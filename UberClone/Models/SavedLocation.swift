//
//  SavedLocation.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-21.
//

import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint
}
