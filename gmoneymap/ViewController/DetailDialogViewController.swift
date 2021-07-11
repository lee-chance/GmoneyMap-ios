//
//  DetailDialogViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/07/11.
//

import Foundation

class DetailDialogViewController: UIViewController {
    
    @IBOutlet weak var shopName: DynamicUILabel!
    @IBOutlet weak var category: DynamicUILabel!
    @IBOutlet weak var address: DynamicUILabel!
    @IBOutlet weak var button: DynamicUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        button.roundCorners(radius: 8, corner: .bottom)
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    func setData(shopName: String?, category: String?, address: String?) {
        self.shopName.text = shopName != nil ? shopName : "-"
        self.category.text = category != nil ? category : "-"
        self.address.text = address != nil ? address : "-"
    }
    
    @IBAction func dismissButton(_ sender: DynamicUIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
