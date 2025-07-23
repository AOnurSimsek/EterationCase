//
//  UIButton+.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import ObjectiveC
import UIKit

private var buttonIDKey: UInt8 = 0

extension UIButton {
    var itemId: Int? {
        get { objc_getAssociatedObject(self, &buttonIDKey) as? Int }
        set { objc_setAssociatedObject(self, &buttonIDKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
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
