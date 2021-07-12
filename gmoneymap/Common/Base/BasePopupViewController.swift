//
//  BasePopupViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/07/12.
//

import Foundation

class BasePopupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
}
