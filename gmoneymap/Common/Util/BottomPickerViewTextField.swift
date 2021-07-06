//
//  BottomPickerViewTextField.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/07/07.
//

import Foundation

class BottomPickerViewTextField: UITextField {
    
    // disable all actions
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
//        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
//            return false
//        }
//        return true
    }
    
}
