//
//  BottomSheetViewController2.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/12.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet var tabBar: UICollectionView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bottomSafeAreaHeight: NSLayoutConstraint!
    @IBOutlet var tabBarIndicatorWidth: NSLayoutConstraint!
    @IBOutlet var tabBarIndicatorLeadingMargin: NSLayoutConstraint!
    
    let tabName = ["데이터", "검색", "메뉴"]
    let tabIcon = [UIImage(systemName: "square.and.arrow.down"), UIImage(systemName: "magnifyingglass"), UIImage(systemName: "line.horizontal.3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        scrollView.delegate = self
        
        tabBar.delegate = self
        tabBar.dataSource = self
        tabBar.registerCustomCollectionViewCell(reuseIdentifier: TabBarCell.rawString)
        
        // 상단 코너 radius
        let f = self.view.frame
        let rect = CGRect(x: f.minX, y: f.minY-Screen.statusBar, width: f.width, height: f.height)
        tabBar.roundCorners(corners: [.topLeft, .topRight], radius: 20, rect: rect)
        view.roundCorners(corners: [.topLeft, .topRight], radius: 20, rect: rect)
        
        bottomSafeAreaHeight.constant = Screen.bottomSafeArea
        tabBarIndicatorWidth.constant = Screen.width / 3
    }

}
