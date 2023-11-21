//
//  SavedLocationSearchView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-18.
//

import SwiftUI

struct SavedLocationSearchView: View {
    @State private var text = ""
    @StateObject var locationSearchVM = LocationSearchViewModel()
    let config: SavedLocationViewModel

    var body: some View {
        VStack {
            TextField("Search for a location...", text: $locationSearchVM.queryFragment)
                .frame(height: 32)
                .padding(.leading)
                .background(Color(.systemGray5))
                .padding()

            Spacer()

            LocationSearchResults(locationSearchVM: locationSearchVM, config: .saveLocation(config))
        }
        .navigationTitle(config.subtitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SavedLocationSearchView(config: .home)
    }
}
