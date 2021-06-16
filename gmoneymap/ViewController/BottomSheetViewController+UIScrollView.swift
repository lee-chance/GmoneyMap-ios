//
//  BottomSheetViewController+UIScrollView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/16.
//

extension BottomSheetViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tabBarIndicatorLeadingMargin.constant = scrollView.contentOffset.x / 3
        // TODO: 해당 메뉴 색상 변경 필요
        // 0 ~ 138
        // 138 ~ 276
//        var index = 0
//        switch scrollView.contentOffset.x / 3 - Screen.width / 3 {
//        case 0..<Screen.width / 3: index = 1
//        case Screen.width / 3: index = 2
//        default: index = 0
//        }
//        tabBar.cellForItem(at: IndexPath(item: index, section: 0))?.backgroundColor = .blue
    }
    
}
