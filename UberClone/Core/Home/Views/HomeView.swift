//
//  HomeView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-07.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState: MapViewState = .noInput

    var body: some View {
        ZStack(alignment: .top) {
            UberMapViewRepresentable(mapState: $mapState)
                .ignoresSafeArea()

            if mapState == .searchingForLocation {
                LocationSearchView(mapState: $mapState)
            } else if mapState == .noInput {
                LocationSearchActivationView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation {
                            mapState = .searchingForLocation
                        }
                    }
            }

            MapViewActionButton(mapState: $mapState)
                .padding(.leading)
                .padding(.top, 4)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LocationSearchViewModel())
}
