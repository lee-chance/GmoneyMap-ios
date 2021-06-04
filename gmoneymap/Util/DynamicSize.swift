//
//  DynamicSize.swift
//  Util
//
//  Created by Changsu Lee on 2021/03/24.
//

import UIKit

let STANDARD_IPHONE_WIDTH: CGFloat = 375
let SCREEN_WIDTH_RADIO: CGFloat = UIScreen.main.bounds.width / STANDARD_IPHONE_WIDTH

@IBDesignable
class DynamicUILabel: UILabel {
    override var font: UIFont! {
        set(newValue) {
            super.font = newValue
        }
        get {
            return super.font.dynamicFont
        }
    }
}

@IBDesignable
class DynamicUIButton: UIButton {
    override var titleLabel: UILabel? {
        get {
            let label = super.titleLabel
            label?.font = label?.font.dynamicFont
            return label
        }
    }
}

@IBDesignable
class DynamicLayoutConstraint: NSLayoutConstraint {
    override var constant: CGFloat {
        set (newValue){
            super.constant = newValue
        }
        get {
            return super.constant.ratioConstant
        }
    }
}
