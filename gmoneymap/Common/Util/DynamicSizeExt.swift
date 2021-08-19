//
//  DynamicSizeExt.swift
//  Util
//
//  Created by Changsu Lee on 2021/03/24.
//

import UIKit

let STANDARD_IPHONE_WIDTH: CGFloat = 375
let SCREEN_WIDTH_RADIO: CGFloat = UIScreen.main.bounds.width / STANDARD_IPHONE_WIDTH

extension Double {
    var ratioConstant: CGFloat { return  CGFloat(self) * SCREEN_WIDTH_RADIO }
}
extension CGFloat {
    var ratioConstant: CGFloat { return  self * SCREEN_WIDTH_RADIO }
}
extension Int {
    var ratioConstant: CGFloat { return  CGFloat(self) * SCREEN_WIDTH_RADIO }
}

extension UIFont {
    var dynamicFont: UIFont {
        let fontName = self.fontName
        let fontSize = self.pointSize
        var calculatedFont = UIFont(name: fontName, size: fontSize.ratioConstant)
        switch fontName {
        case ".SFUI-Regular":
            calculatedFont = .systemFont(ofSize: fontSize.ratioConstant)
        case ".SFUI-Ultralight":
            calculatedFont = .systemFont(ofSize: fontSize.ratioConstant, weight: .ultraLight)
        case ".SFUI-Thin":
            calculatedFont = .systemFont(ofSize: fontSize.ratioConstant, weight: .thin)
        case ".SFUI-Light":
            calculatedFont = .systemFont(ofSize: fontSize.ratioConstant, weight: .light)
        case ".SFUI-Medium":
            calculatedFont = .systemFont(ofSize: fontSize.ratioConstant, weight: .medium)
        case ".SFUI-Semibold":
            calculatedFont = .systemFont(ofSize: fontSize.ratioConstant, weight: .semibold)
        case ".SFUI-Bold":
            calculatedFont = .systemFont(ofSize: fontSize.ratioConstant, weight: .bold)
        case ".SFUI-Heavy":
            calculatedFont = .systemFont(ofSize: fontSize.ratioConstant, weight: .heavy)
        case ".SFUI-Black":
            calculatedFont = .systemFont(ofSize: fontSize.ratioConstant, weight: .black)
        case ".SFUI-RegularItalic":
            calculatedFont = .italicSystemFont(ofSize: fontSize.ratioConstant)
        default:
            break
        }
        return calculatedFont!
    }
}
