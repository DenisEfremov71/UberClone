//
//  User.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-12.
//

import Firebase

enum AccountType: Int, Codable {
    case passenger
    case driver
}

struct User: Codable {
    let uid: String
    let email: String
    let fullname: String
    var coordinates: GeoPoint
    var accountType: AccountType
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
}
