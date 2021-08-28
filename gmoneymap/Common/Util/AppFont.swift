//
//  AppFont.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/08/28.
//

import UIKit

struct AppFontName {
    static let hanullim = "KHNPHanuoolim"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    static var isOverrided: Bool = false
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.hanullim, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
              let _ = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
            self.init(myCoder: aDecoder)
            return
        }
//        var fontName = ""
//        switch fontAttribute {
//        case "CTFontRegularUsage":
//            fontName = AppFontName.regular
//        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
//            fontName = AppFontName.bold
//        case "CTFontObliqueUsage":
//            fontName = AppFontName.italic
//        default:
//            fontName = AppFontName.regular
//        }
        
        let fontName = AppFontName.hanullim
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self, !isOverrided else { return }
        
        isOverrided = true
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySytemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySytemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
           let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
