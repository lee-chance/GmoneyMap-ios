//
//  CategoryViewCell.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit

class CategoryViewCell: BaseViewWithXIB {
    
    @IBOutlet weak var categoryName: CSUILabel!
    
    func setupCell(category: String) {
        categoryName.text = category
    }

}
