//
//  BottomSheetViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/06.
//

import UIKit
import UBottomSheet

class BottomSheetViewController: UIViewController, Draggable {
    
    var sheetCoordinator: UBottomSheetCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .blue
        let f = self.view.frame
        let rect = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
        view.roundCorners(corners: [.topLeft, .topRight], radius: 20, rect: rect)
        sheetCoordinator?.startTracking(item: self)
    }

}
