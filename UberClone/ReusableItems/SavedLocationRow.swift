//
//  SavedLocationRow.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-15.
//

import SwiftUI

struct SavedLocationRow: View {
    let imageName: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(Color(.systemBlue))
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.theme.primaryTextColor)
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .font(.title2)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    SavedLocationRow(imageName: "house.circle.fill", title: "Home", subtitle: "Add Home")
}
