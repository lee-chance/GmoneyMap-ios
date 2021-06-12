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

}
