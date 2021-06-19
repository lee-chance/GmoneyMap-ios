//
//  MapViewController+MTMapViewDelegate.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/19.
//

import Foundation

extension MapViewController: MTMapViewDelegate {
    
    // MARK: - User Location Tracking
    // [User Location Tracking] 단말의 현위치 좌표값을 통보받을 수 있다.
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        // TODO: 현재위치 트래킹(?) 최초만 실행(?)
        let latitude = location.mapPointGeo().latitude
        let longitude = location.mapPointGeo().longitude
        print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
    }
    
    // MARK: - Map View Event
    // [Map View Event] 지도 화면의 이동이 끝난 뒤 호출된다.
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        let latitude = mapCenterPoint.mapPointGeo().latitude
        let longitude = mapCenterPoint.mapPointGeo().longitude
        // TODO: 상단 주소 변경
        print("finishedMapMoveAnimation (\(latitude),\(longitude))")
    }
    
    // [Map View Event] 사용자가 지도 위를 터치한 경우 호출된다.
    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        toggleFullScreen()
    }
    
    // [Map View Event] 지도 중심 좌표가 이동한 경우 호출된다.
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        locationButton.tintColor = .lightGray
    }
    
}
