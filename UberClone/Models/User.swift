//
//  User.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-12.
//

import Foundation

struct User: Codable {
    let uid: String
    let email: String
    let fullname: String
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
}
