//
//  CategoryScrollView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit

class CategoryScrollView: BaseViewWithXIB {

    @IBOutlet var stackView: UIStackView!
    
    override func setupView() {
        super.setupView()
        
        let categoryList = ["모두보기", "음식점1", "음식점2", "상가1", "상가2", "가게1", "가게2", "카페/마트/편의점", "병원/약국/기타의료", "숙박/여행", "레저", "도서/미용/문화", "가전/가구/의류", "학원/교육", "서비스", "제조업", "주유소", "꽃/과일/떡/농업", "건축/건설", "기타"]

        for category in categoryList {
            let cell = CategoryViewCell()
            cell.setupCell(category: category)
            stackView.addArrangedSubview(cell)
        }
        
    }
    
}
