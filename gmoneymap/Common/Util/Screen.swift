//
//  Screen.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/09.
//

import Foundation

struct Screen {
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var statusBar: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 // has bug in IPhone 12 mini
            return window?.safeAreaInsets.top ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    static var navigationBarHeight: CGFloat = 44
    
    static var tabBarHeight: CGFloat = 49
    
    static var bottomSafeArea: CGFloat {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
    
    
}
