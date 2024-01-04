//
//  AuthenticationViewModel.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-11.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift

class AuthenticationViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    private let service = UserService.shared

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

            self.fetchUser()
        }
    }

    func registerUser(withEmail email: String, password: String, fullname: String) {
        guard let location = LocationManager.shared.userLocation else {
            return
        }

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
                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
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
        service.$user
            .sink { [weak self] user in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.currentUser = user
                }
            }
            .store(in: &cancellables)
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
