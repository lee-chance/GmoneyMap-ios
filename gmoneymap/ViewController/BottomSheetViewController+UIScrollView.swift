//
//  BottomSheetViewController+UIScrollView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/16.
//

extension BottomSheetViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tabBarIndicatorLeadingMargin.constant = scrollView.contentOffset.x / 3
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / Screen.width)
        onClickTab(index: index)
    }
    
}
