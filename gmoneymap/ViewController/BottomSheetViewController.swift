//
//  BottomSheetViewController2.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/12.
//

import UIKit

class BottomSheetViewController: UIViewController {

    @IBOutlet var tabBarHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBarHeight.constant = Screen.bottomSafeArea + 60.ratioConstant
    }

}
