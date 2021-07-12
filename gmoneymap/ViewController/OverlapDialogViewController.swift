//
//  OverlapDialogViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/07/12.
//

import Foundation

class OverlapDialogViewController: BasePopupViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var shopList: [RowVO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setData(list: [RowVO]?) {
        loadViewIfNeeded()
        if let list = list {
            shopList = list
            tableViewHeight.constant = CGFloat(list.count) * 47.5
            tableView.reloadData()
        }
    }
    
    @IBAction func dismissButton(_ sender: DynamicUIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension OverlapDialogViewController: UITableViewDelegate, UITableViewDataSource {
    // row when selected : 셀 터치시 회색 표시 없애기, 클릭 액션
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: false) {
            if let rootVC = UIApplication.shared.windows.first!.rootViewController as? ContainerViewController {
                let mapVC = rootVC.contentViewController
                mapVC.detailDialog(row: self.shopList[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopNameCell", for: indexPath)

        cell.textLabel?.text = shopList[indexPath.row].shopName

        return cell
    }
}
