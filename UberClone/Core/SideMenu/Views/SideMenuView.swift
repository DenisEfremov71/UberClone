//
//  SideMenuView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-12.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var authenticationVM: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 40) {
            // header view
            VStack(alignment: .leading, spacing: 32) {
                // user info
                UserInfo()

                // become a driver
                VStack(alignment: .leading, spacing: 16) {
                    Text("Do more with your account")
                        .font(.footnote)
                        .fontWeight(.semibold)

                    HStack {
                        Image(systemName: "dollarsign.square")
                            .font(.title2)
                            .imageScale(.medium)
                        Text("Make Money Driving")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(6)
                    }
                }

                Rectangle()
                    .frame(width: 296, height: 0.75)
                    .opacity(0.7)
                    .foregroundColor(Color(.separator))
                    .shadow(color: .black.opacity(0.7), radius: 4)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)

            // option list
            VStack {
                ForEach(SideMenuOptionViewModel.allCases) { viewModel in
                    NavigationLink(value: viewModel) {
                        SideMenuOptionView(viewModel: viewModel)
                            .padding()
                    }
                }
            }
            .navigationDestination(for: SideMenuOptionViewModel.self) { viewModel in
                switch viewModel {
                case .trips:
                    Text("Trips")
                case .wallet:
                    Text("Wallet")
                case .settings:
                    SettingsView()
                case .messages:
                    Text("Messages")
                }
            }

            Spacer()
        }
        .padding(.top, 32)

    }
}

#Preview {
    NavigationStack {
        SideMenuView()
            .environmentObject(AuthenticationViewModel())
    }
}
