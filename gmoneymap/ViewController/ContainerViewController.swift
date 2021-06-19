//
//  ContainerViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/12.
//

import UIKit

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
