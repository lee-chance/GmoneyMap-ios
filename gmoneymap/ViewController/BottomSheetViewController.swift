//
//  BottomSheetViewController2.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/12.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet var tabBar: UICollectionView!
    @IBOutlet var bottomSafeAreaHeight: NSLayoutConstraint!
    
    let tabName = ["데이터", "검색", "메뉴"]
    let tabIcon = [UIImage(systemName: "square.and.arrow.down"), UIImage(systemName: "magnifyingglass"), UIImage(systemName: "line.horizontal.3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        tabBar.delegate = self
        tabBar.dataSource = self
        tabBar.registerCustomCollectionViewCell(reuseIdentifier: TabBarCell.rawString)
        
        let f = self.view.frame
        let rect = CGRect(x: f.minX, y: f.minY-Screen.statusBar, width: f.width, height: f.height)
        tabBar.roundCorners(corners: [.topLeft, .topRight], radius: 20, rect: rect)
        view.roundCorners(corners: [.topLeft, .topRight], radius: 20, rect: rect)
        
        bottomSafeAreaHeight.constant = Screen.bottomSafeArea
        
        
    }

}

extension BottomSheetViewController: UICollectionViewDelegate {
    // 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Screen.width / 3, height: 60.ratioConstant)
    }
}

extension BottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.rawString, for: indexPath) as! TabBarCell
        
        cell.setText(tabName[indexPath.row])
        cell.setIcon(tabIcon[indexPath.row] ?? UIImage(imageLiteralResourceName: "logo"))
        
        return cell
    }
}

extension BottomSheetViewController: UICollectionViewDelegateFlowLayout {
    // 상하 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 좌우 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 헤더 높이
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: -Screen.statusBar)
    }
}
