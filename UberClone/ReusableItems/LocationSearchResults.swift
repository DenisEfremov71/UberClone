//
//  LocationSearchResults.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-18.
//

import SwiftUI

struct LocationSearchResults: View {
    @StateObject var viewModel: HomeViewModel
    let config: LocationResultsViewConfig

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.results, id: \.self) { result in
                    LocationSearchResultCell(
                        title: result.title,
                        subtitle: result.subtitle
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.selectLocation(result, config: config)
                        }
                    }
                }
            }
        }
    }
}
