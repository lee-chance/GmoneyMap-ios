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
    
    var rowList: [RowVO] = []
    var tagNum = 0
    var map: [String:[RowVO]] = [:]
    
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
        categoryView.search = search(tag:)
        setupSearchButton()
        locationButtonHeight.constant = Screen.bottomSafeArea + 76.ratioConstant
    }
    
    private func clearMapView() {
        // 서클, 마커 삭제
        mapView?.removeAllCircles()
        mapView?.removeAllPOIItems()
    }
    
    private func removeResultListData() {
        // 검색 결과 리스트 삭제
        rowList = []
        tagNum = 0
    }
    
    func search(vo: RowVO) {
        guard let latString = vo.latitude,
              let lonString = vo.longitude,
              let lat = Double(latString),
              let lon = Double(lonString) else {
            return
        }
              
        clearMapView()
        removeResultListData()
        rowList.append(vo)
        
        let mapPoint = MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: lat, longitude: lon))
        delay(interval: 0.5) {
            self.mapView?.setMapCenter(mapPoint, zoomLevel: 1, animated: true)
            self.locationButton.tintColor = .lightGray
        }
        
        let marker = MTMapPOIItem()
        marker.tag = tagNum
        marker.itemName = vo.shopName
        marker.markerType = .redPin
        marker.mapPoint = mapPoint
        marker.customImageAnchorPointOffset = MTMapImageOffset(offsetX: Int32(0.5), offsetY: Int32(1.0))
        mapView?.add(marker)
    }
    
    private func search(tag category: Int) {
        
        print("tag: \(category)") // 100 ~ 119
        
        if selectedSearchButton == .fromMe {
            setMapCenter()
        } else {
            if let latitude = mapView?.mapCenterPoint.mapPointGeo().latitude,
               let longitude = mapView?.mapCenterPoint.mapPointGeo().longitude {
                GMapManager.shared.setCoordinate(latitude: latitude, longitude: longitude)
            }
        }
        
        clearMapView()
        removeResultListData()
        // 겹치는 마커 정보 데이터 리스트 삭제
        map = [:]
        
        showIndicator("불러오는 중...", tapToDismiss: false)
        
        // FIXME: 타 지역에서 현재위치 검색시 타 지역 city로 검색 시도함
        guard let selectedCity = GMapManager.shared.selectedCity else {
            hideIndicator {
                self.customAlert(title: "현재위치는 경기도가 아닙니다.", hasCancel: false)
            }
            return
        }
        
        if GMapManager.shared.downloadedCityList.contains(selectedCity) {
            searchThroughLocalDB(city: selectedCity)
        } else {
            searchThroughNetwork(city: selectedCity)
        }
    }
    
    private func setCircle(radius: Int) {
        let circle = MTMapCircle()
        circle.circleCenterPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: GMapManager.shared.latitude, longitude: GMapManager.shared.longitude))
        circle.circleRadius = Float(radius * 2)
        circle.circleLineColor = UIColor(red: 1/255, green: 104/255, blue: 179/255, alpha: 0.7)
        circle.circleFillColor = UIColor(red: 1/255, green: 104/255, blue: 179/255, alpha: 0.3)
        circle.tag = 5678
        mapView?.addCircle(circle)
    }
    
    private func setNewMarker(row: RowVO) {
        rowList.append(row)
        let marker = MTMapPOIItem()
        marker.tag = tagNum
        if let latString = row.latitude,
           let lonString = row.longitude,
           let lat = Double(latString),
           let lon = Double(lonString) {
            let mapPoint = MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: lat, longitude: lon))
            let xyString = "\(latString) - \(lonString)"
            if let overlapRowList = map[xyString] {
                // 2개 이상의 검색결과는 옐로우핀으로 찍음
                var tempList = overlapRowList
                tempList.append(row)
                map[xyString] = tempList
                marker.itemName = "\(map[xyString]!.count)개의 검색결과"
                marker.markerType = .yellowPin
            } else {
                // 단일 검색결과는 레드핀으로 찍음
                map[xyString] = [row]
                marker.itemName = row.shopName
                marker.markerType = .redPin
            }
            marker.mapPoint = mapPoint
            marker.customImageAnchorPointOffset = MTMapImageOffset(offsetX: Int32(0.5), offsetY: Int32(1.0))
            mapView?.add(marker)
            tagNum += 1
        }
    }
    
    private func searchThroughNetwork(city: String) {
        var rowCount = 0
        let radius = 300
        
        self.viewModel.checkHasData(city: city, onAction: {
            self.hideIndicator()
            self.customAlert(title: nil,
                             message: "\(city)는 더 이상 데이터를 제공하지 않습니다.",
                             okTitle: "확인",
                             okHandler: nil,
                             hasCancel: false)
        }, otherAction: {
            // 원 생성
            self.setCircle(radius: radius)
        }, completion: { [weak self] index, listTotalCount in
            for i in 1...index {
                self?.viewModel.requestAll(index: i, city: city, hideIndicator: {
                    self?.hideIndicator()
                }, onAction: { row in
                    rowCount += 1
                    // 좌표값 확인
                    if let latString = row.latitude,
                       let lonString = row.longitude,
                       let lat = Double(latString),
                       let lon = Double(lonString) {
                        // 내 위치와 거리 비교
                        let distance = Int(sqrt(pow(lat-GMapManager.shared.latitude, 2) + pow(lon-GMapManager.shared.longitude, 2)) * 100000)
                        // 거리가 radius 이내에 있는 값만 마커표시
                        if distance < radius {
                            self?.setNewMarker(row: row)
                        }
                    }
                }, doneAction: {
                    if rowCount == listTotalCount {
                        self?.hideIndicator()
                        self?.showToast("검색을 완료했습니다.", duration: .short)
                    }
                }, failed: {
                    self?.hideIndicator()
                    print("requestAll error occurred!")
                })
            }
        }, failed: {
            self.hideIndicator()
            print("checkHasData error occurred!")
        })
    }
    
    private func searchThroughLocalDB(city: String) {
        let radius = 300
        
        setCircle(radius: radius)
        
        DispatchQueue.global().async {
            if let jsonString = UserDefaults.standard.value(forKey: city) as? String {
                
                guard let data = jsonString.data(using: .utf8),
                      let rows = try? JSONDecoder().decode([RowVO].self, from: data) else {
                    print("Data Error!")
                    DispatchQueue.main.async {
                        self.hideIndicator {
                            self.customAlert(title: "불러오기 오류!",
                                             message: "재시도 하거나 데이터를 다시 다운로드 받아주세요.",
                                             okTitle: "확인",
                                             hasCancel: false)
                        }
                    }
                    return
                }
                
                // 한 데이터씩 확인
                for row in rows {
                    // 좌표값 확인
                    if let latString = row.latitude,
                       let lonString = row.longitude,
                       let lat = Double(latString),
                       let lon = Double(lonString) {
                        // 내 위치와 거리 비교
                        let distance = Int(sqrt(pow(lat-GMapManager.shared.latitude, 2) + pow(lon-GMapManager.shared.longitude, 2)) * 100000)
                        // 거리가 radius 이내에 있는 값만 마커표시
                        if distance < radius {
                            DispatchQueue.main.async {
                                self.setNewMarker(row: row)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.hideIndicator()
                    self.showToast("검색을 완료했습니다.", duration: .short)
                }
            }
        }
    }
    
    private func initMap() {
        setupLocationManager()
        
        mapView = MTMapView(frame: self.mapViewField.bounds)
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
            getCurrentAddress(location: CLLocation(latitude: lat, longitude: lon))
            GMapManager.shared.setCoordinate(latitude: lat, longitude: lon)
            locationButton.tintColor = UIColor(rgb: 0xFF1730)
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
                GMapManager.shared.selectedCity = nil
                return
            }
            
            var address = "\(administrativeArea)"
            
            if let locality = placemark.locality {
                address += " \(locality)"
                if let _ = GMapDefine.City.init(rawValue: locality) {
                    GMapManager.shared.selectedCity = locality
                }
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
            categoryView.resetCells()
            selectedSearchButton = .fromMe
        // search by map
        case 103:
            searchFromMeButton.isSelected = false
            searchByMapButton.isSelected = true
            searchFromMeButton.backgroundColor = .white
            searchByMapButton.backgroundColor = UIColor.appColor(.PrimaryLighter)
            categoryView.resetCells()
            selectedSearchButton = .byMap
        // current location
        case 104:
            // TODO: 위치권한 인증
//            locationManager.requestWhenInUseAuthorization()
            setMapCenter()
        default:
            break
        }
    }
    
}
