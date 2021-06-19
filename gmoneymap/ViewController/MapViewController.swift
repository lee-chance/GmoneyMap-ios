//
//  MapViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit

class MapViewController: UIViewController, MTMapViewDelegate {
    
    @IBOutlet weak var mapViewField: UIView!
    @IBOutlet weak var searchFromMeButton: DynamicUIButton!
    @IBOutlet weak var searchByMapButton: DynamicUIButton!
    
    var mapView: MTMapView?
    
    var showBottomSheet: (()->Void)?
    var hideBottomSheet: (()->Void)?
    var onClickTab: ((Int)->Void)?
    var selectedSearchButton: SearchButton = .fromMe
    
    enum SearchButton {
        case fromMe
        case byMap
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initMap()
    }
    
    private func initView() {
        setupSearchButton()
    }
    
    private func initMap() {
        mapView = MTMapView(frame: self.view.bounds)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            mapViewField.addSubview(mapView)
        }
    }
    
    private func setupSearchButton() {
        searchFromMeButton.roundCorners(radius: searchFromMeButton.bounds.height / 2, corner: [.left])
        searchFromMeButton.setTitleColor(.white, for: .selected)
        searchFromMeButton.setTitleColor(.black, for: .normal)
        searchFromMeButton.backgroundColor = UIColor.appColor(.PrimaryLighter) // initialize background color
        
        searchByMapButton.roundCorners(radius: searchFromMeButton.bounds.height / 2, corner: .right)
        searchByMapButton.setTitleColor(.white, for: .selected)
        searchByMapButton.setTitleColor(.black, for: .normal)
    }

    @IBAction func onClick(_ sender: UIButton) {
        switch sender.tag {
        // current address field click
        case 101:
            showBottomSheet?()
            onClickTab?(1)
        // search from me
        case 102:
            searchFromMeButton.isSelected = true
            searchByMapButton.isSelected = false
            searchFromMeButton.backgroundColor = UIColor.appColor(.PrimaryLighter)
            searchByMapButton.backgroundColor = .white
            selectedSearchButton = .fromMe
        // search by map
        case 103:
            searchFromMeButton.isSelected = false
            searchByMapButton.isSelected = true
            searchFromMeButton.backgroundColor = .white
            searchByMapButton.backgroundColor = UIColor.appColor(.PrimaryLighter)
            selectedSearchButton = .byMap
        default:
            break
        }
    }
    
}
