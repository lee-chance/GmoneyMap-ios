//
//  CategoryViewCell.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit

class CategoryViewCell: BaseViewWithXIB {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var categoryName: CSUILabel!
    
    override func setupView() {
        super.setupView()
        parentView.cornerRadius = parentView.bounds.height / 2
    }
    
    func setupCell(category: String) {
        categoryName.text = category
    }

}
