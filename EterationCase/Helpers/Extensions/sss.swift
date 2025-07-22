//
//  sss.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 22.07.2025.
//

import ObjectiveC
import UIKit.UIButton

private var buttonIDKey: UInt8 = 0

extension UIButton {
    var itemId: Int? {
        get { objc_getAssociatedObject(self, &buttonIDKey) as? Int }
        set { objc_setAssociatedObject(self, &buttonIDKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}
