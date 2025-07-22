//
//  UIButton+.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import UIKit

enum ButtonScaleResponseType {
    case getBigger
    case getSmaller
    
    var scaleFactor: CGFloat {
        switch self {
        case .getBigger:
            return 1.4
        case .getSmaller:
            return 0.8
        }
    }
    
}

extension UIButton {
    func respondtoTap(responseType: ButtonScaleResponseType) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: responseType.scaleFactor,
                                               y: responseType.scaleFactor)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
    
}
