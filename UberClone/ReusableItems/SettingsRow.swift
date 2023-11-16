//
//  SettingsRow.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-15.
//

import SwiftUI

struct SettingsRow: View {
    let imageName: String
    let title: String
    let tintColor: Color

    var body: some View {
        
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(tintColor)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 15))
                    .foregroundColor(Color.theme.primaryTextColor)
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SettingsRow(imageName: "house.circle.fill", title: "Home", tintColor: Color(.systemPurple))
}
