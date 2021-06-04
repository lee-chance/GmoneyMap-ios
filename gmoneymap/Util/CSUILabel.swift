//
//  PaddingLabel.swift
//  Util
//
//  Created by Changsu Lee on 2021/06/02.
//

import Foundation

@IBDesignable
class CSUILabel: DynamicUILabel {
    // MARK: - Padding View
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset.ratioConstant,
                                       left: leftInset.ratioConstant,
                                       bottom: bottomInset.ratioConstant,
                                       right: rightInset.ratioConstant)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: (size.width + leftInset + rightInset).ratioConstant,
                      height: (size.height + topInset + bottomInset).ratioConstant)
    }
}
