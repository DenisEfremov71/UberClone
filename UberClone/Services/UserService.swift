//
//  UserService.swift
//  UberClone
//
//  Created by Denis Efremov on 2024-01-03.
//

import Firebase

class UserService: ObservableObject {

    static let shared = UserService()
    @Published var user: User?

    private init() {
        print("DEBUG: Did init user service")
        fetchUser()
    }

    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

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

            print("DEBUG: Did fetch user from Firestore")

            DispatchQueue.main.async {
                self.user = user
            }
        }
    }
}
