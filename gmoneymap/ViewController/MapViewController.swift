//
//  MapViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit
import UBottomSheet

class MapViewController: UIViewController, MTMapViewDelegate {
    
    @IBOutlet weak var mapViewField: UIView!
    @IBOutlet weak var findConditionField: UIView!
    
    var mapView: MTMapView?
    var sheetCoordinator: UBottomSheetCoordinator!
    var dataSource: UBottomSheetCoordinatorDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initMap()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard sheetCoordinator == nil else { return }
        
        dataSource = PullToDismissDataSource()
        
        sheetCoordinator = UBottomSheetCoordinator(parent: self)
        sheetCoordinator.dataSource = dataSource
        
        let vc = BottomSheetViewController()
        vc.sheetCoordinator = sheetCoordinator
        sheetCoordinator.addSheet(vc, to: self)
        
    }
    
    private func initView() {
        findConditionField.cornerRadius = findConditionField.bounds.height / 2
    }
    
    private func initMap() {
        mapView = MTMapView(frame: self.view.bounds)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            mapViewField.addSubview(mapView)
        }
    }

}
