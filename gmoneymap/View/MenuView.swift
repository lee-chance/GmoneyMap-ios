//
//  MenuView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/14.
//

import UIKit

class MenuView: BaseViewWithXIB, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func setupView() {
        super.setupView()
        
        tableView.registerCustomTableViewCell(reuseIdentifier: MenuTableViewCell.rawString)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.rawString, for: indexPath) as! MenuTableViewCell
        return cell
    }
    
}
