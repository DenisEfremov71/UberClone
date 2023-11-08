//
//  LocationSearchViewModel.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-07.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {

    // MARK: - Properties

    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?

    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }

    // MARK: - Lifecycle

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }

    // MARK: - Helpers

    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with error \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else {
                return
            }
            let coordinate = item.placemark.coordinate

            DispatchQueue.main.async {
                self.selectedLocationCoordinate = coordinate
            }

            print("DEBUG: Location coordinates in LocationSearchViewModel \(coordinate)")
        }
    }

    func locationSearch(
        forLocalSearchCCompletion localSearch: MKLocalSearchCompletion,
        completion: @escaping MKLocalSearch.CompletionHandler
    ) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.results = completer.results
        }
    }
}
