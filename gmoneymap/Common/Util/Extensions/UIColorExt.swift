//
//  UIColorExt.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/18.
//

extension UIColor {
    
    // MARK: - Use Assets Color
    enum AssetsColor: String {
        case GMapBackBlue
        case GMapDarkBlue
        case GMapGreen
        case GMapMint
        case LightGray
        case PrimaryLighter
    }
    
    static func appColor(_ name: AssetsColor) -> UIColor? {
         return UIColor(named: name.rawValue)
    }
    
    // MARK: - hex color init
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    // USAGE: UIColor(rgb: 0xFFFFFF)
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
