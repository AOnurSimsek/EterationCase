//
//  Double+.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import Foundation

extension Double {
    func getPrice() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return (formatter.string(from: NSNumber(value: self)) ?? "-1") + " ₺"

    }
    
}
