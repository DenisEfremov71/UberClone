//
//  AuthenticationViewModel.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-11.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthenticationViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
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

            // TODO: - Add error handling
            guard let result = result else {
                print("DEBUG: No result returned from Firebase")
                return
            }

            DispatchQueue.main.async {
                self.userSession = result.user
            }

            let user = User(
                uid: result.user.uid,
                email: email,
                fullname: fullname,
                coordinates: GeoPoint(latitude: 49.0, longitude: -123.0),
                accountType: .driver,
                homeLocation: nil,
                workLocation: nil
            )

            // TODO: - Add error handling
            guard let encodedUser = try? Firestore.Encoder().encode(user) else {
                return
            }

            Firestore.firestore().collection("users").document(result.user.uid).setData(encodedUser)
        }
    }

    func fetchUser() {
        guard let uid = userSession?.uid else {
            return
        }

        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else {
                return
            }

            // TODO: - Add error handling
            guard error == nil else {
                print("DEBUG: Failed to retrieve data for user with error \(error?.localizedDescription ?? "")")
                return
            }

            // TODO: - Add error handling
            guard let snapshot = snapshot else {
                print("DEBUG: No snapshot returned")
                return
            }

            // TODO: - Add error handling
            guard let user = try? snapshot.data(as: User.self) else {
                print("DEBUG: Failed to decode data")
                return
            }

            DispatchQueue.main.async {
                self.currentUser = user
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            // TODO: - Add error handling
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
}
