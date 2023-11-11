//
//  AuthenticationViewModel.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-11.
//

import Foundation
import Firebase

class AuthenticationViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?

    init() {
        userSession = Auth.auth().currentUser
    }
}
