//
//  UserInfo.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-15.
//

import SwiftUI

struct UserInfo: View {
    @EnvironmentObject var authenticationVM: AuthenticationViewModel
    let navigationEnabled: Bool

    init(navigationEnabled: Bool = false) {
        self.navigationEnabled = navigationEnabled
    }

    var body: some View {
        HStack {
            Image("male-profile-photo")
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 8) {
                Text(authenticationVM.currentUser?.fullname ?? "")
                    .font(.system(size: 16, weight: .semibold))
                Text(authenticationVM.currentUser?.email ?? "")
                    .font(.system(size: 14))
                    .accentColor(Color.theme.primaryTextColor)
                    .opacity(0.7)
            }

            if navigationEnabled {
                Spacer()
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }

    }
}

#Preview {
    UserInfo(navigationEnabled: true)
        .environmentObject(AuthenticationViewModel())
}
