//
//  SearchViewModel.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/20.
//

import Foundation
import Moya

class SearchViewModel {
    
    let provider = MoyaProvider<GMapService>(plugins: [VerbosePlugin(verbose: false), NetworkActivityPlugin(networkActivityClosure: { change , target in
//        print("network indicator: \(change), \(target.path)")
//        DispatchQueue.main.async {
//            switch change {
//            case .began:
//                HJIndicator.shared.show()
//            case .ended:
//                HJIndicator.shared.hide()
//            }
//        }
    })])
    
    func checkHasData(city: String,
                      completion: @escaping (RegionMnyFacltStusVO)->Void,
                      failed: (()->Void)?) {
        provider.request(.getList(index: 1, city: city)) { result in
            switch result {
            case .success(let response):
                do {
                    let res = try JSONDecoder().decode(ResponseVO.self, from: response.data)
                    
                    guard let regionMnyFacltStus = res.RegionMnyFacltStus else {
                        print("no longer provide data")
                        failed?()
                        return
                    }
                    
                    completion(regionMnyFacltStus[0])
                    
                } catch {
                    print("catched!")
                    failed?()
                }
            case .failure(let error):
                print("erro: \(error)")
                failed?()
            }
        }
    }
    
    func requestAll(index: Int,
                    city: String,
                    completion: @escaping (ResponseVO)->Void,
                    failed: (()->Void)?) {
        provider.request(.getList(index: index, city: city)) { result in
            switch result {
            case .success(let response):
                do {
                    let res = try JSONDecoder().decode(ResponseVO.self, from: response.data)
                    
                    completion(res)
                    
                } catch {
                    print("catched!")
                    failed?()
                }
            case .failure(let error):
                print("erro: \(error)")
                failed?()
            }
        }
    }
    
}
