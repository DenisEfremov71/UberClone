//
//  HomeView.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-07.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState: MapViewState = .noInput
    @State private var showSideMenu = false
    //@EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @EnvironmentObject var authenticationVM: AuthenticationViewModel
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        Group {
            if authenticationVM.userSession == nil {
                LoginView()
            } else {
                NavigationStack {
                    ZStack {
                        if showSideMenu {
                            SideMenuView()
                        }
                        mapView
                            .offset(x: showSideMenu ? 316 : 0)
                            .shadow(color: showSideMenu ? .black : .clear, radius: 10)
                    }
                    .onAppear {
                        showSideMenu = false
                    }
                }
                .onAppear {
                    authenticationVM.fetchUser()
                }
            }
        }
    }
}

extension HomeView {
    var mapView: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()

                if mapState == .searchingForLocation {
                    LocationSearchView()
                } else if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation {
                                mapState = .searchingForLocation
                            }
                        }
                }

                MapViewActionButton(mapState: $mapState, showSideMenu: $showSideMenu)
                    .padding(.leading)
                    .padding(.top, 4)
            }

            if mapState == .locationSelected || mapState == .polylineAdded {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                homeVM.userLocation = location
            }
        }
        .onReceive(homeVM.$selectedUberLocation) { location in
            if location != nil {
                mapState = .locationSelected
            }
        }
    }
}

#Preview {
    HomeView()
        //.environmentObject(LocationSearchViewModel())
        .environmentObject(AuthenticationViewModel())
        .environmentObject(HomeViewModel())
}
