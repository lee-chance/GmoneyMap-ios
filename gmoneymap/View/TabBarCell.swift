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
    
    override var isSelected: Bool {
        didSet {
            tab.textColor = isSelected ? UIColor.appColor(.PrimaryLighter) : .black
            icon.tintColor = isSelected ? UIColor.appColor(.PrimaryLighter) : .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setText(_ text: String) {
        tab.text = text
        tab.textColor = .black
    }
    
    func setIcon(_ image: UIImage?) {
        icon.image = image
        icon.tintColor = .black
    }
}
