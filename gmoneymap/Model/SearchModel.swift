//
//  File.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/20.
//

import Foundation

struct ResponseVO: Codable {
    var RegionMnyFacltStus: [RegionMnyFacltStusVO]?
}

struct RegionMnyFacltStusVO: Codable {
    var head: [HeadVO]?
    var row: [RowVO]?
}

struct HeadVO: Codable {
    var list_total_count: Int?
    var RESULT: ResultVO?
    var api_version: String?
}

struct RowVO: Codable {
    var shopName: String?
    var categoryName: String?
    var telNumber: String?
    var locationAddress: String?
    var roadAddress: String?
    var longitude: String?
    var latitude: String?
    var cityCode: String?
    var cityName: String?
    
    enum CodingKeys: String, CodingKey {
        case shopName = "CMPNM_NM"
        case categoryName = "INDUTYPE_NM"
//        case telNumber = "CMPNM_NM"
        case locationAddress = "REFINE_LOTNO_ADDR"
        case roadAddress = "REFINE_ROADNM_ADDR"
        case longitude = "REFINE_WGS84_LOGT"
        case latitude = "REFINE_WGS84_LAT"
        case cityCode = "SIGUN_CD"
        case cityName = "SIGUN_NM"
    }
    
}

struct ResultVO: Codable {
    var CODE: String?
    var MESSAGE: String?
}
