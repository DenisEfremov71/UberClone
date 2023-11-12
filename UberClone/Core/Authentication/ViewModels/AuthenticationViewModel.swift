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

    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [unowned self] result, error in

            // TODO: - Add error handling
            if let error = error {
                print("DEBUG: Filed to sign in with error \(error.localizedDescription)")
                return
            }

            guard let result = result else {
                print("DEBUG: No result returned from Firebase")
                return
            }

            DispatchQueue.main.async {
                self.userSession = result.user
            }
        }
    }

    func registerUser(withEmail email: String, password: String, fullname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] result, error in

            // TODO: - Add error handling
            if let error = error {
                print("DEBUG: Filed to sign up with error \(error.localizedDescription)")
                return
            }

            guard let result = result else {
                print("DEBUG: No result returned from Firebase")
                return
            }

            DispatchQueue.main.async {
                self.userSession = result.user
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            // TODO: - Add error handling
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
}
