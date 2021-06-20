//
//  MapViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapViewField: UIView!
    @IBOutlet weak var currentAddressView: UIView!
    @IBOutlet weak var currentAddressLabel: CSUILabel!
    @IBOutlet weak var searchFromMeButton: DynamicUIButton!
    @IBOutlet weak var searchByMapButton: DynamicUIButton!
    @IBOutlet weak var categoryView: CategoryScrollView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationButtonHeight: NSLayoutConstraint!
    
    var mapView: MTMapView?
    var locationManager: CLLocationManager!
    
    var showBottomSheet: (()->Void)?
    var initBottomSheet: (()->Void)?
    var hideBottomSheet: (()->Void)?
    var onClickTab: ((Int)->Void)?
    var selectedSearchButton: SearchButton = .fromMe
    var isFullScreen: Bool = false
    
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
        locationButtonHeight.constant = Screen.bottomSafeArea + 76.ratioConstant
    }
    
    private func initMap() {
        setupLocationManager()
        
        mapView = MTMapView(frame: self.view.bounds)
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            
            setMapCenter()
            
            // 현재 위치 트래킹
            mapView.showCurrentLocationMarker = true
            mapView.currentLocationTrackingMode = .onWithoutHeading
            
            // DEBUG: 마커 추가
            let mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude:  37.2725511, longitude: 127.2034024))
            let poiItem1 = MTMapPOIItem()
            poiItem1.markerType = MTMapPOIItemMarkerType.bluePin
            poiItem1.mapPoint = mapPoint1
            poiItem1.itemName = "아무데나 찍어봄"
            mapView.add(poiItem1)
            
            mapViewField.addSubview(mapView)
        }
    }
    
    private func setupSearchButton() {
        searchFromMeButton.roundCorners(radius: searchFromMeButton.bounds.height / 2, corner: .left)
        searchFromMeButton.setTitleColor(.white, for: .selected)
        searchFromMeButton.setTitleColor(.black, for: .normal)
        searchFromMeButton.backgroundColor = UIColor.appColor(.PrimaryLighter) // initialize background color
        
        searchByMapButton.roundCorners(radius: searchFromMeButton.bounds.height / 2, corner: .right)
        searchByMapButton.setTitleColor(.white, for: .selected)
        searchByMapButton.setTitleColor(.black, for: .normal)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 배터리에 맞게 권장되는 최적의 정확도
        locationManager.startUpdatingLocation()
    }
    
    private func setMapCenter() {
        if let lat = locationManager.location?.coordinate.latitude,
           let lon = locationManager.location?.coordinate.longitude {
            mapView?.setMapCenter(.init(geoCoord: MTMapPointGeo(latitude: lat, longitude: lon)), animated: true)
        }
    }
    
    func getCurrentAddress(location: CLLocation) {
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error -> Void in
            guard error == nil else {
                print("error: \(String(describing: error))")
                self.currentAddressLabel.text = "위치를 찾을 수 없습니다."
                return
            }
            
            guard let placemark = placemarks?.first else {
                self.currentAddressLabel.text = "위치를 찾을 수 없습니다."
                return
            }
            
            guard let administrativeArea = placemark.administrativeArea,
                  administrativeArea.contains("경기도") else {
                self.currentAddressLabel.text = "현 위치는 경기도가 아닙니다."
                return
            }
            
            var address = "\(administrativeArea)"
            
            if let locality = placemark.locality {
                address += " \(locality)"
            }
            
            if let subLocality = placemark.subLocality {
                address += " \(subLocality)"
            }
            
            if let thoroughfare = placemark.thoroughfare,
               placemark.subLocality != placemark.thoroughfare {
                address += " \(thoroughfare)"
            }
            
            if let subThoroughfare = placemark.subThoroughfare {
                address += " \(subThoroughfare)"
            }
            
            self.currentAddressLabel.text = address
        }
    }
    
    func toggleFullScreen() {
        currentAddressView.isHidden = !isFullScreen
        searchFromMeButton.isHidden = !isFullScreen
        searchByMapButton.isHidden = !isFullScreen
        categoryView.isHidden = !isFullScreen
        locationButton.isHidden = !isFullScreen
        isFullScreen ? initBottomSheet?() : hideBottomSheet?()
        
        isFullScreen = !isFullScreen
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
        // current location
        case 104:
            print("location button")
//            locationManager.requestWhenInUseAuthorization()
            setMapCenter()
            sender.tintColor = UIColor(rgb: 0xFF1730)
        default:
            break
        }
    }
    
}
