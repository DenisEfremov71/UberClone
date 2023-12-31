//
//  SavedLocationViewModel.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-17.
//

import Foundation

enum SavedLocationViewModel: Int, CaseIterable, Identifiable {
    case home
    case work

    var id: Int {
        return self.rawValue
    }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .work:
            return "Work"
        }
    }

    var subtitle: String {
        switch self {
        case .home:
            return "Add Home"
        case .work:
            return "Add Work"
        }
    }

    var imageName: String {
        switch self {
        case .home:
            return "house.circle.fill"
        case .work:
            return "archivebox.circle.fill"
        }
    }

    var databaseKey: String {
        switch self {
        case .home:
            return "homeLocation"
        case .work:
            return "workLocation"
        }
    }

    func subtitle(forUser user: User?) -> String {
        switch self {
        case .home:
            return user?.homeLocation?.title ?? "Add Home"
        case .work:
            return user?.workLocation?.title ?? "Add Work"
        }
    }
}
