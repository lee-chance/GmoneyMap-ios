//
//  MapViewController+MTMapViewDelegate.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/19.
//

import CoreLocation

extension MapViewController: MTMapViewDelegate {
    
    // MARK: - User Location Tracking
    // [User Location Tracking] 단말의 현위치 좌표값을 통보받을 수 있다.
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let latitude = location.mapPointGeo().latitude
        let longitude = location.mapPointGeo().longitude
        print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
        GMapManager.shared.setCoordinate(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Map View Event
    // [Map View Event] 지도 화면의 이동이 끝난 뒤 호출된다.
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        let latitude = mapCenterPoint.mapPointGeo().latitude
        let longitude = mapCenterPoint.mapPointGeo().longitude
        getCurrentAddress(location: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    // [Map View Event] 사용자가 지도 위를 터치한 경우 호출된다.
    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        toggleFullScreen()
    }
    
    // [Map View Event] 지도 중심 좌표가 이동한 경우 호출된다.
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        locationButton.tintColor = .lightGray
    }
    
    // MARK: - POI Item
    // [POI Item] 단말 사용자가 POI Item 아이콘(마커) 위에 나타난 말풍선(Callout Balloon)을 터치한 경우 호출된다.
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        // TODO: 마커 클릭 이벤트 처리
        switch poiItem.markerType {
        case MTMapPOIItemMarkerType.redPin: // 단일결과
            detailDialog(row: rowList[poiItem.tag])
        case MTMapPOIItemMarkerType.yellowPin: // 다중결과, 검색결과
            print("yellowPin")
        case MTMapPOIItemMarkerType.bluePin:
            print("bluePin")
        default: break
        }
    }
    
}

// custom dialog
extension MapViewController {
    
    // 단일검색 다이얼로그
    private func detailDialog(row: RowVO) {
        
        guard let vc = UIViewController.instantiate(viewController: DetailDialogViewController.rawString, in: .Main) as? DetailDialogViewController else {
            return
        }
        
        vc.loadViewIfNeeded() // vc initialize
        let address = row.roadAddress != nil ? row.roadAddress : row.locationAddress
        vc.setData(shopName: row.shopName, category: row.categoryName, address: address)
        present(vc, animated: true, completion: nil)
    }
}
