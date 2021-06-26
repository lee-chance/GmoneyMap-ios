//
//  MapViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit
import CoreLocation

class MapViewController: BaseViewController {
    
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
    let viewModel = SearchViewModel()
    
    var showBottomSheet: (()->Void)?
    var initBottomSheet: (()->Void)?
    var hideBottomSheet: (()->Void)?
    var onClickTab: ((Int)->Void)?
    var selectedSearchButton: SearchButton = .fromMe
    var isFullScreen: Bool = false
    
    var stringList: [String] = []
    var map: [String:Int] = [:]
    var overlapCount: Int = 0
    
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
        categoryView.search = search
        setupSearchButton()
        locationButtonHeight.constant = Screen.bottomSafeArea + 76.ratioConstant
    }
    
    private func search() {
        // TODO: 프로그래스바, 데이터 초기화(?)
        var rowCount = 0
        let radius = 300
        
        showIndicator("불러오는 중...")
        
        guard let selectedCity = GMapManager.shared.selectedCity else {
            print("검색 중 오류가 발생했습니다.")
            hideIndicator()
            return
        }
        self.viewModel.checkHasData(city: selectedCity) { [weak self] vo in
            guard let heads = vo.head,
                  let listTotalCount = heads[0].list_total_count else {
                self?.hideIndicator()
                return
            }
            let index = listTotalCount / 100 + 1

            // 원 생성
            self?.setCircle(radius: radius)
            
            for i in 1...index {
                self?.viewModel.requestAll(index: i, city: selectedCity) { vo in

                    // 결과코드가 성공인지 확인
                    guard let heads = vo.RegionMnyFacltStus?[0].head,
                          let code = heads[1].RESULT?.CODE,
                          code == "INFO-000" else {
                        print("code error") // FIXME: Fix me here
                        self?.hideIndicator()
                        return
                    }

                    // rows 데이터가 있는지 확인
                    guard let rows = vo.RegionMnyFacltStus?[1].row else {
                        print("no data")
                        self?.hideIndicator()
                        return
                    }

                    // 한 데이터씩 확인
                    for row in rows {
                        rowCount += 1
                        // 좌표값 확인
                        if let latString = row.REFINE_WGS84_LAT,
                           let lonString = row.REFINE_WGS84_LOGT,
                           let lat = Double(latString),
                           let lon = Double(lonString) {
                            // 내 위치와 거리 비교
                            let distance = Int(sqrt(pow(lat-GMapManager.shared.latitude!, 2) + pow(lon-GMapManager.shared.longitude!, 2)) * 100000)
                            // 거리가 radius 이내에 있는 값만 마커표시
                            if distance < radius {
                                self?.setNewMarker(row: row)
                            }
                        }
                        if rowCount == listTotalCount {
                            self?.hideIndicator()
                            self?.showToast("검색을 완료했습니다.", duration: .short)
                        }
                    }
                } failed: {
                    self?.hideIndicator()
                    print("error occurred!")
                }
            }
        }
    }
    
    private func setCircle(radius: Int) {
        let circle = MTMapCircle()
        circle.circleCenterPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: GMapManager.shared.latitude!, longitude: GMapManager.shared.longitude!))
        circle.circleRadius = Float(radius * 2)
        circle.circleLineColor = UIColor(red: 1/255, green: 104/255, blue: 179/255, alpha: 0.7)
        circle.circleFillColor = UIColor(red: 1/255, green: 104/255, blue: 179/255, alpha: 0.3)
        circle.tag = 5678
        mapView?.addCircle(circle)
    }
    
    private func setNewMarker(row: RowVO) {
//        rowList.add(row)
        let marker = MTMapPOIItem()
//        marker.userObject = row
//        marker.tag = tagNum
        if let latString = row.REFINE_WGS84_LAT,
           let lonString = row.REFINE_WGS84_LOGT,
           let lat = Double(latString),
           let lon = Double(lonString) {
            let mapPoint = MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: lat, longitude: lon))
            let xyString = "\(latString) - \(lonString)"
            if stringList.contains(xyString) {
                // 2개 이상의 검색결과는 옐로우핀으로 찍음
                if let count = map[xyString] {
                    overlapCount = count
                } else {
                    overlapCount = 1
                }
                overlapCount += 1
                map[xyString] = overlapCount
                marker.itemName = "\(overlapCount)개의 검색결과"
                marker.markerType = .yellowPin
            } else {
                // 단일 검색결과는 레드핀으로 찍음
                stringList.append(xyString)
                marker.itemName = row.CMPNM_NM
                marker.markerType = .redPin
            }
            marker.mapPoint = mapPoint
            marker.customImageAnchorPointOffset = MTMapImageOffset(offsetX: Int32(0.5), offsetY: Int32(1.0))
            mapView?.add(marker)
//            tagNum += 1
        }
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
