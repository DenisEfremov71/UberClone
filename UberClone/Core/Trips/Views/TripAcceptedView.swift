//
//  TripAcceptedView.swift
//  UberClone
//
//  Created by Denis Efremov on 2024-01-20.
//

import SwiftUI

struct TripAcceptedView: View {
    var body: some View {
        VStack {
            Text("Your driver is on the way")
                .padding()
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

#Preview {
    TripAcceptedView()
}
