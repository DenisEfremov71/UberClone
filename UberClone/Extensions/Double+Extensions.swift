//
//  Double+Extensions.swift
//  UberClone
//
//  Created by Denis Efremov on 2023-11-09.
//

import Foundation

extension Double {
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }

    private var distanceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter
    }

    func toCurrency() -> String {
        currencyFormatter.string(for: self) ?? ""
    }

    func distanceInMilesString() -> String {
        distanceFormatter.string(for: self / 1609) ?? ""
    }
}
