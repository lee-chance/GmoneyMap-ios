//
//  PullToDismissDataSource.swift
//  UBottomSheet_Example
//
//  Created by ugur on 2.05.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import UBottomSheet

class PullToDismissDataSource: UBottomSheetCoordinatorDataSource {
    
    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
        return [availableHeight, availableHeight-83, 0.1]
    }
    
    func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
        return availableHeight-83
    }
}
