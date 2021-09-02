//
//  BottomSheetViewController+UICollectionView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/16.
//

extension BottomSheetViewController: UICollectionViewDelegate {
    // 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Screen.width / 3, height: 60.ratioConstant)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // FIXME: 클로저로 변경 필요.. 어떻게 하지?
//        onClickTabClosure
        onClickTab(index: indexPath.row)
        scrollView.setContentOffset(CGPoint(x: indexPath.row * Int(Screen.width), y: 0), animated: true)
        showBottomSheet?()
    }
}

extension BottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCell.rawString, for: indexPath) as! TabBarCell
        
        cell.setText(tabName[indexPath.row])
        cell.setIcon(tabIcon[indexPath.row])
        
        if indexPath.row == 0 {
            cell.isSelected = true
        }
        
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
