//
//  ContainerViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/12.
//

import UIKit

import MessageUI

class ContainerViewController: BottomSheetContainerViewController<MapViewController, BottomSheetViewController> {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentViewController.showBottomSheet = showBottomSheetClosure()
        contentViewController.initBottomSheet = initBottomSheetClosure()
        contentViewController.hideBottomSheet = hideBottomSheetClosure()
        contentViewController.onClickTab = bottomSheetViewController.onClickTabClosure()
        
        bottomSheetViewController.showBottomSheet = showBottomSheetClosure()
//        bottomSheetViewController.initBottomSheet = initBottomSheetClosure()
    }

}

extension ContainerViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
