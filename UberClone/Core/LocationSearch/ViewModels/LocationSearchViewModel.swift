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
    @Published var selectedLocation: String?

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

    func selectLocation(_ location: String) {
        DispatchQueue.main.async {
            self.selectedLocation = location
        }

        print("DEBUG: Selected location is \(selectedLocation ?? "")")
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
