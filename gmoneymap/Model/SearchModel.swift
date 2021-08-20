//
//  File.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/20.
//

import Foundation

struct ResponseVO: Codable {
    var response: [RegionMnyFacltStusVO]?
    
    enum CodingKeys: String, CodingKey {
        case response = "RegionMnyFacltStus"
    }
}

struct RegionMnyFacltStusVO: Codable {
    var head: [HeadVO]?
    var row: [RowVO]?
}

struct HeadVO: Codable {
    var listTotalCount: Int?
    var resultVO: ResultVO?
    var apiVersion: String?
    
    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case resultVO = "RESULT"
        case apiVersion = "api_version"
    }
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
    var code: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}
