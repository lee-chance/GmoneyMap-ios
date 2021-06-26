//
//  UIViewExt.swift
//  Util
//
//  Created by Changsu Lee on 2021/06/02.
//

extension UIView {
    
    enum CSCornerMask {
        case all
        case top
        case left
        case right
        case bottom
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        
        func toCACornerMask() -> CACornerMask {
            switch self {
            case .all:
                return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .top:
                return [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            case .left:
                return [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .right:
                return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            case .bottom:
                return [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            case .topLeft:
                return [.layerMinXMinYCorner]
            case .topRight:
                return [.layerMaxXMinYCorner]
            case .bottomLeft:
                return [.layerMinXMaxYCorner]
            case .bottomRight:
                return [.layerMaxXMaxYCorner]
            }
        }
    }
    
    func roundCorners(radius: CGFloat, corner: CSCornerMask) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(arrayLiteral: corner.toCACornerMask())
    }
    
    func roundCorners(radius: CGFloat, corner: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(arrayLiteral: corner)
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset : CGSize{
        get {
            return layer.shadowOffset
        }
        set{
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor : UIColor{
        get {
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity : Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}
