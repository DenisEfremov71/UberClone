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
    var currentUser: User?
    var routeToPickupLocation: MKRoute?

    @Published var drivers = [User]()
    @Published var trip: Trip?

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
                guard let self = self else { return }
                self.currentUser = user
                guard let user = user else { return }

                if user.accountType == .passenger {
                    self.fetchDrivers()
                    self.addTripObserverForPassenger()
                } else if user.accountType == .driver {
                    self.addTripObserverForDriver()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Location Search Helpers

extension HomeViewModel {
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""

        if let thoroughfare = placemark.thoroughfare {
            result += thoroughfare
        }

        if let subthoroughfare = placemark.subThoroughfare {
            result += " \(subthoroughfare)"
        }

        if let subadministrativearea = placemark.subAdministrativeArea {
            result += ", \(subadministrativearea)"
        }

        return result
    }

    func getPlacemark(forLocation location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }

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
        guard let destCoordinate = selectedUberLocation?.coordinate else {
            return 0.0
        }
        guard let userCoordinate = self.userLocation else {
            return 0.0
        }

        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destination = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)
        let tripDistanceInMeters = userLocation.distance(from: destination)

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

// MARK: - Passenger API

extension HomeViewModel {
    func addTripObserverForPassenger() {
        guard let currentUser = currentUser, currentUser.accountType == .passenger else { return }

        Firestore.firestore().collection("trips")
            .whereField("passengerUid", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DEBUG: Error in snapshot listener \(error.localizedDescription)")
                }

                guard let change = snapshot?.documentChanges.first, change.type == .added || change.type == .modified else { return }
                guard let trip = try? change.document.data(as: Trip.self) else { return }

                self.trip = trip

                print("DEBUG: Updated trip state is \(trip.state)")
            }
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

    func requestTrip() {
        guard let driver = drivers.first else { return }
        guard let currentUser = currentUser else { return }
        guard let dropoffLocation = selectedUberLocation else { return }

        let dropoffGeoPoint = GeoPoint(
            latitude: dropoffLocation.coordinate.latitude,
            longitude: dropoffLocation.coordinate.longitude
        )

        let userLocation = CLLocation(
            latitude: currentUser.coordinates.latitude,
            longitude: currentUser.coordinates.longitude
        )

        getPlacemark(forLocation: userLocation) { [weak self] placemark, error in
            guard let self = self else { return }
            guard let placemark = placemark else { return }

            let tripCost = self.computeRidePrice(forType: .uberX)

            let trip = Trip(
                passengerUid: currentUser.uid,
                driverUid: driver.uid,
                passengerName: currentUser.fullname,
                driverName: driver.fullname,
                passengerLocation: currentUser.coordinates,
                driverLocation: driver.coordinates,
                pickupLocationName: placemark.name ?? "Current user location",
                dropoffLocationName: dropoffLocation.title,
                pickupLocationAddress: self.addressFromPlacemark(placemark),
                pickupLocation: currentUser.coordinates,
                dropoffLocation: dropoffGeoPoint,
                tripCost: tripCost,
                distanceToPassenger: 0,
                travelTimeToPassenger: 0,
                state: .requested
            )

            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else { return }
            Firestore.firestore().collection("trips").document().setData(encodedTrip) { error in
                if let error = error {
                    print("DEBUG: Error = \(error.localizedDescription)")
                } else {
                    print("DEBUG: Did upload trip to firestore")
                }
            }
        }
    }
}

// MARK: - Driver API

extension HomeViewModel {
    func addTripObserverForDriver() {
        guard let currentUser = currentUser, currentUser.accountType == .driver else { return }

        Firestore.firestore().collection("trips")
            .whereField("driverUid", isEqualTo: currentUser.uid)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DEBUG: Error in snapshot listener \(error.localizedDescription)")
                }

                guard let change = snapshot?.documentChanges.first, change.type == .added || change.type == .modified else { return }
                guard let trip = try? change.document.data(as: Trip.self) else { return }

                self.trip = trip

                self.getDestinationRoute(from: trip.driverLocation.toCoordinate(), to: trip.pickupLocation.toCoordinate()) { route in
                    self.routeToPickupLocation = route
                    self.trip?.travelTimeToPassenger = Int(route.expectedTravelTime / 60)
                    self.trip?.distanceToPassenger = route.distance
                }
            }
    }

//    func fetchTrips() {
//        guard let currentUser = currentUser else { return }
//
//        Firestore.firestore().collection("trips")
//            .whereField("driverUid", isEqualTo: currentUser.uid)
//            .getDocuments { snapshot, error in
//                guard error == nil else {
//                    print("DEBUG: Failed getting trips with error \(error?.localizedDescription ?? "")")
//                    return
//                }
//
//                guard let documents = snapshot?.documents, let document = documents.first else { return }
//                guard let trip = try? document.data(as: Trip.self) else { return }
//
//                self.trip = trip
//
//                self.getDestinationRoute(
//                    from: trip.driverLocation.toCoordinate(),
//                    to: trip.pickupLocation.toCoordinate()) { route in
//                        self.trip?.travelTimeToPassenger = Int(route.expectedTravelTime / 60)
//                        self.trip?.distanceToPassenger = route.distance
//                    }
//            }
//    }

    func rejectTrip() {
        updateTripState(state: .rejected)
    }

    func acceptTrip() {
        updateTripState(state: .accepted)
    }

    private func updateTripState(state: TripState) {
        guard let trip = trip else { return }

        var data = ["state": state.rawValue]

        if state == .accepted {
            data["travelTimeToPassenger"] = trip.travelTimeToPassenger
        }

        Firestore.firestore().collection("trips").document(trip.id).updateData(data) { error in
            if let error = error {
                print("DEBUG: Failed to update trips, Error = \(error.localizedDescription)")
                return
            } else {
                print("DEBUG: Did update trip with state \(state)")
            }
        }
    }
}
