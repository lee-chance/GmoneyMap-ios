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
    
    var selectedCity: String? = GMapDefine.City.용인시.rawValue
    var latitude: Double? = 37.266722
    var longitude: Double? = 127.2140459
}
