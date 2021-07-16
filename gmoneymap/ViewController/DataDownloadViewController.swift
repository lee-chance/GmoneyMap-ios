//
//  DataDownloadViewController.swift
//  gmoneymap
//
//  Created by HelloDigital on 2021/07/16.
//

import UIKit

class DataDownloadViewController: BaseViewController {

    @IBOutlet weak var downloadView: DownloadView!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        statusBarHeight.constant = Screen.statusBar
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .fullScreen
    }

    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
