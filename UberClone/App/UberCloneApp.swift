//
//  UberCloneApp.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-07.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct UberCloneApp: App {
    @StateObject var locationSearchVM = LocationSearchViewModel()
    @StateObject var authenticationVM = AuthenticationViewModel()

    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(locationSearchVM)
                .environmentObject(authenticationVM)
        }
    }
}
