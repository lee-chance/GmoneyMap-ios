//
//  UITableViewExt.swift
//  Util
//
//  Created by Changsu Lee on 2021/03/24.
//

import UIKit

extension UICollectionView {
    func registerCustomCollectionViewCell(reuseIdentifier: String) {
        let nib = UINib.init(nibName: reuseIdentifier, bundle: Bundle.main)
        self.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
