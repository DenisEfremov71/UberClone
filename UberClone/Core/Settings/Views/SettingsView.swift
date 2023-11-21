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
                    .padding(8)
                }
                
                Section("Favorites") {
                    ForEach(SavedLocationViewModel.allCases) { viewModel in
                        NavigationLink {
                            SavedLocationSearchView(config: viewModel)
                        } label: {
                            SavedLocationRow(viewModel: viewModel)
                        }
                    }
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
                    .onTapGesture {
                        authenticationVM.signOut()
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    SettingsView()
    .environmentObject(AuthenticationViewModel())
}
