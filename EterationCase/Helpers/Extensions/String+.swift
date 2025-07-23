//
//  String+.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 23.07.2025.
//

import Foundation

extension String {
    func toISODate() -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime,
            .withFractionalSeconds]
        return formatter.date(from: self) ?? Date()
    }
    
}
