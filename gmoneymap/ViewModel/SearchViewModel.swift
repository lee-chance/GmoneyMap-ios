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
                      onAction: (()->Void)?,
                      otherAction: (()->Void)? = nil,
                      completion: @escaping (Int, Int)->Void,
                      failed: (()->Void)?) {
        provider.request(.getList(index: 1, city: city)) { result in
            switch result {
            case .success(let response):
                do {
                    let res = try JSONDecoder().decode(ResponseVO.self, from: response.data)
                    
                    guard let regionMnyFacltStus = res.response else {
                        print("no longer provide data")
                        failed?()
                        return
                    }
                    
                    let completionData = self.checkHasDataCompletion(regionMnyFacltStus[0], onAction, otherAction)
                    completion(completionData.0, completionData.1)
                    
                } catch {
                    print("catched!")
                    failed?()
                }
            case .failure(let error):
                print("error: \(error)")
                failed?()
            }
        }
    }
    
    func requestAll(index: Int,
                    city: String,
                    hideIndicator: (() -> Void)!,
                    onAction: ((RowVO)->Void)?,
                    doneAction: (()->Void)?,
//                    completion: @escaping (ResponseVO)->Void,
                    failed: (()->Void)?) {
        provider.request(.getList(index: index, city: city)) { result in
            switch result {
            case .success(let response):
                do {
                    let res = try JSONDecoder().decode(ResponseVO.self, from: response.data)
                    
                    self.requestAllCompletion(res, hideIndicator, onAction, doneAction: doneAction)
                    
                } catch {
                    print("catched!")
                    failed?()
                }
            case .failure(let error):
                print("error: \(error)")
                failed?()
            }
        }
    }
}


extension SearchViewModel {
    
    private func checkHasDataCompletion(_ vo: RegionMnyFacltStusVO, _ onAction: (()->Void)?, _ otherAction: (()->Void)?) -> (Int, Int) {
        guard let heads = vo.head,
              let listTotalCount = heads[0].listTotalCount else {
            (onAction ?? {})()
            return (0, 0)
        }
        
        (otherAction ?? {})()
        
        let index = listTotalCount / 100 + 1
        return (index, listTotalCount)
    }
    
    private func requestAllCompletion(_ vo: ResponseVO, _ hideIndicator: ()->Void, _ onAction: ((RowVO)->Void)?, doneAction: (()->Void)?) {
        // 결과코드가 성공인지 확인
        guard let heads = vo.response?[0].head,
              let code = heads[1].resultVO?.code,
              code == "INFO-000" else {
            print("code error")
            hideIndicator()
            return
        }
        
        // rows 데이터가 있는지 확인
        guard let rows = vo.response?[1].row else {
            print("no data")
            hideIndicator()
            return
        }
        
        // 한 데이터씩 확인
        for row in rows {
            (onAction ?? { _ in })(row)
        }
        
        (doneAction ?? {})()
    }
}
