//
//  UIViewExt.swift
//  Util
//
//  Created by Changsu Lee on 2021/06/02.
//

extension UIView {
    
    
    // ex) view.roundCorners(corners: [.topLeft, .topRight], radius: 20, rect: rect)
    func roundCorners(corners: UIRectCorner, radius: CGFloat, rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
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
