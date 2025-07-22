//
//  UIButton+.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import UIKit

extension UIButton {
    func respondtoTap() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8,
                                               y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
    
}
