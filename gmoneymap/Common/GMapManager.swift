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
    
    var categoryMap: [String : [String]]? {
        get {
//            if let decoded = UserDefaults.standard.object(forKey: GMapDefine.UserDefaultsKey.categoryMap.rawValue) as? Data {
//                return NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Int : [String]]
//            } else {
//                return nil
//            }
            return UserDefaults.standard.dictionary(forKey: GMapDefine.UserDefaultsKey.categoryMap.rawValue) as? [String : [String]]
        }
        set {
//            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: newValue)
//            UserDefaults.standard.set(encodedData, forKey: GMapDefine.UserDefaultsKey.categoryMap.rawValue)
            UserDefaults.standard.set(newValue, forKey: GMapDefine.UserDefaultsKey.categoryMap.rawValue)
        }
    }
    
    var downloadedCityList: [String] {
        get {
            return UserDefaults.standard.array(forKey: GMapDefine.UserDefaultsKey.downloadedCityList.rawValue) as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: GMapDefine.UserDefaultsKey.downloadedCityList.rawValue)
        }
    }
    
    var selectedCity: String? = nil
    // 디폴트 경기도청
    var latitude: Double = 37.2749065
    var longitude: Double = 127.0091901
    
    func setCoordinate(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
