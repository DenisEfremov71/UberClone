//
//  LocationSearchResults.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-18.
//

import SwiftUI

struct LocationSearchResults: View {
    @StateObject var locationSearchVM: LocationSearchViewModel
    let config: LocationResultsViewConfig

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(locationSearchVM.results, id: \.self) { result in
                    LocationSearchResultCell(
                        title: result.title,
                        subtitle: result.subtitle
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            locationSearchVM.selectLocation(result, config: config)
                        }
                    }
                }
            }
        }
    }
}
