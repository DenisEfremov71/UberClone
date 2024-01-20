//
//  TripLoadingView.swift
//  UberClone
//
//  Created by Denis Efremov on 2024-01-20.
//

import SwiftUI

struct TripLoadingView: View {
    var body: some View {
        VStack {
            Text("Finding you a ride...")
                .padding()
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

#Preview {
    TripLoadingView()
}
