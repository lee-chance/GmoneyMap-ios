//
//  VerbosePlugin.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/20.
//

import Foundation
import Moya

struct VerbosePlugin: PluginType {
    
    let verbose: Bool
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        if verbose {
//            #if DEBUG
            print("Request:\(request.debugDescription)")
            if let body = request.httpBody,
                let str = String(data: body, encoding: .utf8) {
                print("request to send: \(str))")
            }
//            #endif
        }
        
        return request
    }
    func willSend(_ request: RequestType, target: TargetType) {
        
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
         
        switch result {
        case .success(let body):
            if verbose {
//                #if DEBUG
                print("Response:")
                if let json = try? JSONSerialization.jsonObject(with: body.data, options: .mutableContainers) {
                    let str = String(describing: json)
                    print( str )
                } else {
                    let response = String(data: body.data, encoding: .utf8)!
                    print(response)
                }
//                #endif
            }
        case .failure( _):
            break
        }
        
    }
}
