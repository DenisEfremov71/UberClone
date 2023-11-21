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
            HStack(spacing: 16) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .imageScale(.medium)
                    .padding(.leading)
                TextField("Search for a location...", text: $locationSearchVM.queryFragment)
                    .frame(height: 32)
                    .padding(.leading)
                    .background(Color(.systemGray5))
                    .padding(.trailing)
            }
            .padding(.top)

            Spacer()

            LocationSearchResults(locationSearchVM: locationSearchVM, config: .saveLocation(config))
        }
        .navigationTitle(config.subtitle)
    }
}

#Preview {
    NavigationStack {
        SavedLocationSearchView(config: .home)
    }
}
