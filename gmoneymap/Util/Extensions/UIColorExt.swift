//
//  UIColorExt.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/18.
//

enum AssetsColor: String {
    case GMapBackBlue
    case GMapDarkBlue
    case GMapGreen
    case GMapMint
    case PrimaryLighter
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
         return UIColor(named: name.rawValue)
    }
}
