//
//  UberMapViewRepresentable.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-07.
//

import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable {

    let mapView = MKMapView()
    let locationManager = LocationManager()
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel

    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("DEBUG: Map state is \(mapState)")

        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationSearchVM.selectedLocationCoordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
        }
    }

    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(parent: self)
    }

}

extension UberMapViewRepresentable {

    class MapCoordinator: NSObject, MKMapViewDelegate {

        // MARK: - Properties

        let parent: UberMapViewRepresentable
        var userLocationCCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?

        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }

        // MARK: - MKMapViewDelegate

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            userLocationCCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 6
            return renderer
        }

        // MARK: - Helpers

        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mapView.addAnnotation(annotation)
            parent.mapView.selectAnnotation(annotation, animated: true)
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }

        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = userLocationCCoordinate else {
                return
            }
            getDestinationRoute(from: userLocationCoordinate, to: coordinate) { [weak self] route in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.parent.mapView.addOverlay(route.polyline)
                }
            }
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

            directions.calculate { response, error in
                // TODO: - Add error handling
                if let error = error {
                    print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                    return
                }

                guard let route = response?.routes.first else {
                    // TODO: - Add error handling
                    return
                }

                completion(route)
            }
        }

        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)

            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }

}
