//
//  UIViewControllerExt.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/12.
//

import Foundation

extension UIViewController {
    
    class func instantiate(viewController: String, in storyboard: GMapDefine.Storyboard) -> UIViewController {
        let std = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        let vc = std.instantiateViewController(withIdentifier: viewController)
        return vc
    }
    
}
