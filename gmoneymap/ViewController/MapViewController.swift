//
//  MapViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit

class MapViewController: UIViewController, MTMapViewDelegate {
    
    @IBOutlet weak var mapViewField: UIView!
    @IBOutlet weak var findConditionField: UIView!
    
    var mapView: MTMapView?
    
    var showBottomSheet: (()->Void)?
    var hideBottomSheet: (()->Void)?
    var onClickTab: ((Int)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initMap()
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

    @IBAction func onClick(_ sender: UIButton) {
        switch sender.tag {
        // current address field click
        case 101:
            showBottomSheet?()
            onClickTab?(1)
        default:
            break
        }
    }
    
}
