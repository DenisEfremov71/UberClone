//
//  SettingsView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-15.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authenticationVM: AuthenticationViewModel

    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        UserInfo(navigationEnabled: true)
                    }
                }

                Section("Favorites") {
                    SavedLocationRow(
                        imageName: "house.circle.fill",
                        title: "Home",
                        subtitle: "Add Home"
                    )
                    SavedLocationRow(
                        imageName: "archivebox.circle.fill",
                        title: "Work",
                        subtitle: "Add Work"
                    )
                }

                Section("Settings") {
                    SettingsRow(
                        imageName: "bell.circle.fill",
                        title: "Notifications",
                        tintColor: Color(.systemPurple)
                    )
                    SettingsRow(
                        imageName: "creditcard.circle.fill",
                        title: "Payment Methods",
                        tintColor: Color(.systemBlue)
                    )
                }

                Section("Account") {
                    SettingsRow(
                        imageName: "dollarsign.square.fill",
                        title: "Make money driving",
                        tintColor: Color(.systemGreen)
                    )
                    SettingsRow(
                        imageName: "arrow.left.square.fill",
                        title: "Sign out",
                        tintColor: Color(.systemRed)
                    )
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthenticationViewModel())
}
