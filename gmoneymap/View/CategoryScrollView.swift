//
//  CategoryScrollView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit

class CategoryScrollView: BaseViewWithXIB {

    @IBOutlet var stackView: UIStackView!
    
    let categoryList = GMapDefine.Category.allCases
    
    var search: (()->Void)?
    
    override func setupView() {
        super.setupView()
        
        addPaddingView(width: 16.ratioConstant)

        for (i, category) in categoryList.enumerated() {
            let cell = CategoryViewCell()
            cell.tag = 100 + i
            cell.setupCell(category: category.rawValue)
            cell.onClick = {
                self.resetCells()
                let c = self.viewWithTag(cell.tag) as? CategoryViewCell
                c?.parentView.backgroundColor = .appColor(.PrimaryLighter)
                c?.categoryName.textColor = .white
                
                self.search?()
            }
            stackView.addArrangedSubview(cell)
        }
        
        addPaddingView(width: 16.ratioConstant)
    }
    
    private func addPaddingView(width: CGFloat) {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        stackView.addArrangedSubview(view)
    }
    
    private func resetCells() {
        for i in 0..<categoryList.count {
            let tag = 100 + i
            let cell = viewWithTag(tag) as? CategoryViewCell
            cell?.parentView.backgroundColor = .white
            cell?.categoryName.textColor = .black
        }
    }
    
}
