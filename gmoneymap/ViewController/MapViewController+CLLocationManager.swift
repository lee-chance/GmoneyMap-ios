//
//  MapViewController+CLLocationManager.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/19.
//

import Foundation
import CoreLocation

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // TODO: 실 기기 테스트 및 구현 필요
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
//            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            locationManager.requestWhenInUseAuthorization()
//            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
}
