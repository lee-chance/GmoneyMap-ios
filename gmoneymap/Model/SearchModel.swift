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
    var CMPNM_NM: String?
    var INDUTYPE_NM: String?
    var DATA_STD_DE: String?
    var REFINE_LOTNO_ADDR: String?
    var REFINE_ROADNM_ADDR: String?
    var REFINE_ZIP_CD: String?
    var REFINE_WGS84_LOGT: String?
    var REFINE_WGS84_LAT: String?
    var SIGUN_CD: String?
    var SIGUN_NM: String?
}

struct ResultVO: Codable {
    var CODE: String?
    var MESSAGE: String?
}
