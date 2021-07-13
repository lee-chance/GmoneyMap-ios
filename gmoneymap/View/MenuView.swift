//
//  MenuView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/14.
//

import UIKit

class MenuView: BaseViewWithXIB {
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuList = ["📋  공지사항", "💾  데이터 다운로드", "❌  오류제보", "⭐️  평점주기", "💕  공유하기", "ℹ️  앱 정보"]
    
    override func setupView() {
        super.setupView()
        
        tableView.registerCustomTableViewCell(reuseIdentifier: MenuTableViewCell.rawString)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // 공지사항
    private func showNoticeList() {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
    }
    
    // 앱 정보
    private func showAppInfoPopup() {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        guard let vc = UIViewController.instantiate(viewController: AppInfoPopupViewController.rawString, in: .Popup) as? AppInfoPopupViewController else {
            return
        }
        
        vc.loadViewIfNeeded()
        rootVC.present(vc, animated: true, completion: nil)
    }
    
}

extension MenuView: UITableViewDataSource, UITableViewDelegate {
    
    var cellHeight: CGFloat { return 52.ratioConstant }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: // 공지사항
            showNoticeList()
        case 1: // 데이터 다운로드
            // TODO: 데이터 다운로드
            print(menuList[1])
        case 2: // 오류제보
            // TODO: 오류제보
            print(menuList[2])
        case 3: // 평점주기
            // TODO: 평점주기
            print(menuList[3])
        case 4: // 공유하기
            // TODO: 공유하기
            print(menuList[4])
        case 5: // 앱 정보
            showAppInfoPopup()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.rawString, for: indexPath) as! MenuTableViewCell
        
        cell.textLabel?.text = menuList[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.ratioConstant)
        
        let bottomView = UIView(frame: CGRect(x: 0, y: cellHeight, width: Screen.width, height: -1))
        bottomView.backgroundColor = .lightGray
        cell.addSubview(bottomView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
