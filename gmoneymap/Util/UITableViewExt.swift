//
//  UITableViewExt.swift
//  Util
//
//  Created by Changsu Lee on 2021/03/24.
//

import UIKit

extension UITableView {
    
    func registerCustomTableViewCell(reuseIdentifier: String) {
        let nib = UINib.init(nibName: reuseIdentifier, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func registerCustomHeaderCell(reuseIdentifier: String) {
        let nib = UINib.init(nibName: reuseIdentifier, bundle: Bundle.main)
        self.register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
}
