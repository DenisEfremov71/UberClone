//
//  UberCloneApp.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-07.
//

import SwiftUI

@main
struct UberCloneApp: App {
    @StateObject var locationSearchVM = LocationSearchViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationSearchVM)
        }
    }
}
