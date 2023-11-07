//
//  LocationSearchResultCell.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-07.
//

import SwiftUI

struct LocationSearchResultCell: View {
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .accentColor(.white)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text("Starbucks Coffee")
                    .font(.body)
                Text("123 Main St, Cuprtino CA")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Divider()
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
        }
        .padding(.leading)
    }
}

#Preview {
    LocationSearchResultCell()
}
