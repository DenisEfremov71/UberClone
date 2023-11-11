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

    func registerUser(withEmail email: String, password: String, fullname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            // TODO: - Add error handling
            if let error = error {
                print("DEBUG: Filed to sign up with error \(error.localizedDescription)")
                return
            }

            guard let result = result else {
                print("DEBUG: No result returned from Firebase")
                return
            }

            print("DEBUG: Registered user \(fullname) successfully")
            print("DEBUG: User ID \(result.user.uid)")
        }
    }
}
