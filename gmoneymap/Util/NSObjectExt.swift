//
//  NSObjectExt.swift
//  Util
//
//  Created by Changsu Lee on 2021/03/24.
//

import Foundation

extension NSObject {
    
    static var rawString: String {
        return "\(self)"
    }
    
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            closure()
        }
    }
}
