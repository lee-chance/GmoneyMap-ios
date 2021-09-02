//
//  MapViewController+CLLocationManager.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/19.
//

import Foundation
import CoreLocation

extension MapViewController: CLLocationManagerDelegate {
    
    func locationSettingAlert() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined, .restricted, .denied:
            customAlert(title: "위치권한 설정이 필요합니다.",
                        message: "앱 설정화면으로 이동하시겠습니까?",
                        okTitle: "네",
                        okHandler: { _ in
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings)
                            }
                        },
                        cancelTitle: "아니요")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            locationSettingAlert()
        case .denied:
            print("GPS 권한 요청 거부됨")
            locationSettingAlert()
        default:
            print("GPS: Default")
        }
    }
    
}
