//
//  User+Extensions.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-22.
//

import Firebase

extension User {
    static var mockUser: User {
        User(
            uid: UUID().uuidString,
            email: "jdoe@testdomain.com",
            fullname: "John Doe",
            coordinates: GeoPoint(latitude: 49.26383, longitude: -123.14612),
            accountType: .passenger,
            homeLocation: nil,
            workLocation: nil
        )
    }
}
