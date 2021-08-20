//
//  BottomSheetViewController2.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/12.
//

import UIKit

class BottomSheetViewController: BaseViewController {

    @IBOutlet var tabBar: UICollectionView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var downloadView: DownloadView!
    @IBOutlet var searchView: SearchView!
    @IBOutlet var menuView: MenuView!
    @IBOutlet var bottomSafeAreaHeight: NSLayoutConstraint!
    @IBOutlet var tabBarIndicatorWidth: NSLayoutConstraint!
    @IBOutlet var tabBarIndicatorLeadingMargin: NSLayoutConstraint!
    
    let tabName = ["다운로드", "검색", "메뉴"]
    let tabIcon = [UIImage(systemName: "square.and.arrow.down"), UIImage(systemName: "magnifyingglass"), UIImage(systemName: "line.horizontal.3")]
    
    var showBottomSheet: (()->Void)?
    var hideBottomSheet: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        downloadView.parentVC = self
        
        scrollView.delegate = self
        
        tabBar.delegate = self
        tabBar.dataSource = self
        tabBar.registerCustomCollectionViewCell(reuseIdentifier: TabBarCell.rawString)
        
        // 상단 코너 radius
        tabBar.roundCorners(radius: 20, corner: .top)
        view.roundCorners(radius: 20, corner: .top)
        
        bottomSafeAreaHeight.constant = Screen.bottomSafeArea + 3
        tabBarIndicatorWidth.constant = Screen.width / 3
    }
    
    func onClickTab(index: Int) {
        for i in 0..<3 {
            tabBar.cellForItem(at: IndexPath(item: i, section: 0))?.isSelected = false
        }
        tabBar.cellForItem(at: IndexPath(item: index, section: 0))?.isSelected = true
    }
    
    func onClickTabClosure() -> (Int)->Void {
        return { [weak self] index in
            self?.onClickTab(index: index)
            self?.scrollView.setContentOffset(CGPoint(x: index * Int(Screen.width), y: 0), animated: true)
            self?.showBottomSheet?()
        }
    }

}
