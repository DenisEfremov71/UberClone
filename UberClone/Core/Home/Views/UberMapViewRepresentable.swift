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
    @Binding var mapState: MapViewState
    //@EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @EnvironmentObject var homeVM: HomeViewModel

    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow

        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
            context.coordinator.addDriversToMap(homeVM.drivers)
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = homeVM.selectedUberLocation?.coordinate {
                print("DEBUG: Adding stuff to map...")
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
        case .polylineAdded:
            break
        case .tripAccepted:
            guard let trip = homeVM.trip else { return }
            guard let currentUser = homeVM.currentUser, currentUser.accountType == .driver else { return }
            guard let route = homeVM.routeToPickupLocation else { return }
            context.coordinator.configurePolylineToPickupLocation(withRoute: route)
            context.coordinator.addAndSelectAnnotation(withCoordinate: trip.pickupLocation.toCoordinate())
        default:
            break
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

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                view.image = UIImage(systemName: "chevron.right.circle.fill")
                return view
            }
            return nil
        }

        // MARK: - Helpers

        func configurePolylineToPickupLocation(withRoute route: MKRoute) {
            self.parent.mapView.addOverlay(route.polyline)
            let rect = self.parent.mapView.mapRectThatFits(
                route.polyline.boundingMapRect,
                edgePadding: .init(top: 88, left: 32, bottom: 435, right: 32)
            )
            self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }

        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.mapView.addAnnotation(annotation)
            parent.mapView.selectAnnotation(annotation, animated: true)

        }

        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = userLocationCCoordinate else {
                return
            }
            parent.homeVM.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { [weak self] route in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.parent.mapView.addOverlay(route.polyline)
                    self.parent.mapState = .polylineAdded
                    let rect = self.parent.mapView.mapRectThatFits(
                        route.polyline.boundingMapRect,
                        edgePadding: .init(top: 64, left: 32, bottom: 535, right: 32)
                    )
                    self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                }
            }
        }

        func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)

            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }

        func addDriversToMap(_ drivers: [User]) {
            let annotations = drivers.map(DriverAnnotation.init)
            self.parent.mapView.addAnnotations(annotations)
        }
    }

}
