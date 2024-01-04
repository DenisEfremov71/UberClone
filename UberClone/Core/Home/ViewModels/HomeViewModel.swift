//
//  HomeViewModel.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-23.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel: ObservableObject {

    @Published var drivers = [User]()
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchUser()
    }

    func fetchUser() {
        service.$user
            .sink { [weak self] user in
                guard let self = self, let user = user else { return }
                guard user.accountType == .passenger else { return }
                self.fetchDrivers()
            }
            .store(in: &cancellables)
    }

    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { [weak self] snapshot, _ in
                guard let self = self else { return }
                guard let documents = snapshot?.documents else {
                    return
                }

                let drivers = documents.compactMap { try? $0.data(as: User.self) }
                DispatchQueue.main.async {
                    self.drivers = drivers
                }
            }
    }
}
