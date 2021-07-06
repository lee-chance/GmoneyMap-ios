//
//  GMapManager.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/26.
//

import Foundation

class GMapManager {
    static let shared = GMapManager()
    
    let key = "4ec8d71038ca488cb7805fb00e2b5309"
    
    var downloadedDatas: [String : [DataModel]] = [:]
    
    var selectedCity: String? = nil
    // 디폴트 경기도청
    var latitude: Double = 37.2749065
    var longitude: Double = 127.0091901
    
    func setCoordinate(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
