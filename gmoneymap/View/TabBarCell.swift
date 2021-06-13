//
//  TabBarViewCell.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/12.
//

import UIKit

class TabBarCell: UICollectionViewCell {

    @IBOutlet var icon: UIImageView!
    @IBOutlet var tab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setText(_ text: String) {
        tab.text = text
        tab.textColor = .black
    }
    
    func setIcon(_ image: UIImage) {
        icon.image = image
        icon.tintColor = .black
    }
}
