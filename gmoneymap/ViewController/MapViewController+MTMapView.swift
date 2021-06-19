//
//  MapViewController+MTMapViewDelegate.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/19.
//

import Foundation

extension MapViewController: MTMapViewDelegate {
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        // TODO: 현재위치 트래킹(?) 최초만 실행(?)
        let latitude = location.mapPointGeo().latitude
        let longitude = location.mapPointGeo().longitude
        print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
    }
    
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
    
}
