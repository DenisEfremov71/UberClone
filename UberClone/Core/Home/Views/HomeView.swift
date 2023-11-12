//
//  HomeView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-07.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState: MapViewState = .noInput
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @EnvironmentObject var authenticationVM: AuthenticationViewModel

    var body: some View {
        Group {

            if authenticationVM.userSession == nil {
                LoginView()
            } else {
                ZStack(alignment: .bottom) {
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

                    if mapState == .locationSelected || mapState == .polylineAdded {
                        RideRequestView()
                            .transition(.move(edge: .bottom))
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .onReceive(LocationManager.shared.$userLocation, perform: { location in
                    if let location = location {
                        locationSearchVM.userLocation = location
                    }
                })
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(LocationSearchViewModel())
        .environmentObject(AuthenticationViewModel())
}
