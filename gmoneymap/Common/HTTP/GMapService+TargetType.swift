//
//  GMapService+TargetType.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/20.
//

import Moya

extension GMapService: TargetType {
    
    var path: String {
        switch self {
        case .getList: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getList(let index, let city):
            var parameters: [String:Any] = ["Type":"json", "KEY":GMapManager.shared.key]
//            var parameters: [String:Any] = ["Type":"json"]
            if let index = index {
                parameters["pIndex"] = index
            }
            if let city = city {
                parameters["SIGUN_NM"] = city
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getList: return ["Content-type":"application/json;charset=UTF-8"]
        }
    }
    
    var baseURL: URL {
        return URL(string: "https://openapi.gg.go.kr/RegionMnyFacltStus")!
    }
    
    var sampleData: Data {
        return "sampleData is not supported".data(using: .utf8)!
    }
}
