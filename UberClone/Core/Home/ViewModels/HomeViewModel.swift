//
//  HomeViewModel.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-23.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestoreSwift
import MapKit

class HomeViewModel: NSObject, ObservableObject {

    // MARK: - Properties

    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var drivers = [User]()

    // Locaion search properties
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation: UberLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?

    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }

    // MARK: - Lificycle

    override init() {
        super.init()
        fetchUser()
        searchCompleter.queryFragment = queryFragment
        searchCompleter.delegate = self
    }

    // MARK: - User API

    func fetchUser() {
        service.$user
            .sink { [weak self] user in
                guard let self = self, let user = user else { return }
                guard user.accountType == .passenger else { return }
                self.fetchDrivers()
            }
            .store(in: &cancellables)
    }

    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { [weak self] snapshot, _ in
                guard let self = self else { return }
                guard let documents = snapshot?.documents else {
                    return
                }

                let drivers = documents.compactMap { try? $0.data(as: User.self) }
                DispatchQueue.main.async {
                    self.drivers = drivers
                }
            }
    }
}

// MARK: - Location Search Helpers

extension HomeViewModel {
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig) {
        locationSearch(forLocalSearchCompletion: localSearch) { [weak self] response, error in
            guard let self = self else {
                return
            }

            if let error = error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else {
                return
            }
            let coordinate = item.placemark.coordinate

            switch config {
            case .ride:
                DispatchQueue.main.async {
                    self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
                }
            case .saveLocation(let savedLocationViewModel):
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                let savedLocation = SavedLocation(
                    title: localSearch.title,
                    address: localSearch.subtitle,
                    coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                )
                guard let encodedLocation = try? Firestore.Encoder().encode(savedLocation) else {
                    return
                }
                Firestore.firestore().collection("users").document(uid).updateData([
                    savedLocationViewModel.databaseKey: encodedLocation
                ])
            }
        }
    }

    func locationSearch(
        forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
        completion: @escaping MKLocalSearch.CompletionHandler
    ) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }

    func computeRidePrice(forType type: RideType) -> Double {
        guard let coordinate = selectedUberLocation?.coordinate, let userLocation = userLocation else {
            return 0.0
        }

        let start = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let tripDistanceInMeters = destination.distance(from: start)

        return type.computePrice(for: tripDistanceInMeters)
    }

    func getDestinationRoute(
        from userLocation: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (MKRoute) -> Void
    ) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        let directions = MKDirections(request: request)

        directions.calculate { [weak self] response, error in
            guard let self = self else {
                return
            }

            // TODO: - Add error handling
            if let error = error {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                return
            }

            guard let route = response?.routes.first else {
                // TODO: - Add error handling
                return
            }

            self.configurePickupAndDropoffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }

    func configurePickupAndDropoffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"

        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.results = completer.results
        }
    }
}
