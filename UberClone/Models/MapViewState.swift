//
//  MapViewState.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-08.
//

import Foundation

enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
    case polylineAdded
    case tripRequested
    case tripAccepted
    case tripRejected
    case tripCancelledByPassenger
    case tripCancelledByDriver
}
