//
//  LocationSearchView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-07.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel

    var body: some View {
        VStack {
            // header view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }

                VStack {
                    TextField("Current location", text: $startLocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    TextField("Where to?", text: $locationSearchVM.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                }
            }
            .padding(.horizontal)
            .padding(.top, 64)

            Divider()
                .padding(.vertical)

            // list view
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(locationSearchVM.results, id: \.self) { result in
                        LocationSearchResultCell(
                            title: result.title,
                            subtitle: result.subtitle
                        )
                        .onTapGesture {
                            withAnimation(.spring()) {
                                locationSearchVM.selectLocation(result)
                                mapState = .locationSelected
                            }
                        }
                    }
                }
            }
        }
        .background(Color.theme.backgroundColor)
        //.background(.white)
    }
}

#Preview {
    LocationSearchView(mapState: .constant(.noInput))
        .environmentObject(LocationSearchViewModel())
}
