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

    func toCurrency() -> String {
        currencyFormatter.string(for: self) ?? ""
    }
}
