//
//  ResultViewController+Search.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/08/19.
//

import Foundation

extension ResultViewController {
    private func checkShopNameAndAppend(row: RowVO) {
        let keyword = searchKeyword.2
        let shopName = row.shopName
        if keyword.isEmpty || shopName?.contains(keyword) ?? false {
            let category = row.categoryName
            let roadAddress = row.roadAddress
            let locationAddress = row.locationAddress
            let telNumber = row.telNumber
            let latitude = row.latitude
            let longitude = row.longitude
            let cityCode = row.cityCode
            let cityName = row.cityName
            let data = RowVO(shopName: shopName, categoryName: category, telNumber: telNumber, locationAddress: locationAddress, roadAddress: roadAddress, longitude: longitude, latitude: latitude, cityCode: cityCode, cityName: cityName)
            datas.append(data)
        }
    }
    
    private func checkAddressAndAppend(row: RowVO) {
        let keyword = searchKeyword.2
        let roadAddress = row.roadAddress
        let locationAddress = row.locationAddress
        if keyword.isEmpty || roadAddress?.contains(keyword) ?? false || locationAddress?.contains(keyword) ?? false {
            let shopName = row.shopName
            let category = row.categoryName
            let telNumber = row.telNumber
            let latitude = row.latitude
            let longitude = row.longitude
            let cityCode = row.cityCode
            let cityName = row.cityName
            let data = RowVO(shopName: shopName, categoryName: category, telNumber: telNumber, locationAddress: locationAddress, roadAddress: roadAddress, longitude: longitude, latitude: latitude, cityCode: cityCode, cityName: cityName)
            datas.append(data)
        }
    }
    
    
    // MARK: - Search Local DB
    func searchThroughLocalDB(city: String, type: String) {
        showIndicator("불러오는 중...")
        switch type {
        case "상호명":
            searchShopNameFromDB(city: city)
        case "주소":
            searchAddressFromDB(city: city)
        default: break
        }
    }
    
    private func searchShopNameFromDB(city: String) {
        DispatchQueue.main.async {
            if let jsonString = UserDefaults.standard.value(forKey: city) as? String {
                
                guard let data = jsonString.data(using: .utf8),
                      let rows = try? JSONDecoder().decode([RowVO].self, from: data) else {
                    print("엥")
                    return
                }
                
                // 한 데이터씩 확인
                for row in rows {
                    self.checkShopNameAndAppend(row: row)
                }
                
                self.resultCountLabel.text = "\(self.datas.count)개의 검색결과"
                self.resultListTableView.reloadData()
                self.showToast("검색을 완료했습니다.", duration: .short)
                
                self.delay(interval: 0.3) {
                    self.hideIndicator()
                }
            }
        }
    }
    
    private func searchAddressFromDB(city: String) {
        DispatchQueue.main.async {
            if let jsonString = UserDefaults.standard.value(forKey: city) as? String {
                
                guard let data = jsonString.data(using: .utf8),
                      let rows = try? JSONDecoder().decode([RowVO].self, from: data) else {
                    print("엥")
                    return
                }
                
                // 한 데이터씩 확인
                for row in rows {
                    self.checkAddressAndAppend(row: row)
                }
                
                self.resultCountLabel.text = "\(self.datas.count)개의 검색결과"
                self.resultListTableView.reloadData()
                self.showToast("검색을 완료했습니다.", duration: .short)
                
                self.delay(interval: 0.3) {
                    self.hideIndicator()
                }
            }
        }
    }
    
    // MARK: - Search Network
    func searchThroughNetwork(city: String, type: String) {
        switch type {
        case "상호명":
            searchShopName(city: city)
        case "주소":
            searchAddress(city: city)
        default: break
        }
    }
    
    // FIXME: 클린코드 필요..ㅠ
    private func searchAddress(city: String) {
        var rowCount = 0
        
        self.showIndicator("불러오는 중...")
        
        self.viewModel.checkHasData(city: city) { [weak self] vo in
            guard let heads = vo.head,
                  let listTotalCount = heads[0].list_total_count else {
                self?.hideIndicator()
                
                self?.customAlert(title: nil,
                                  message: "\(city)는 더 이상 데이터를 제공하지 않습니다.",
                                  okTitle: "확인",
                                  okHandler: nil,
                                  hasCancel: false)
                return
            }
            let index = listTotalCount / 100 + 1
            
            for i in 1...index {
                self?.viewModel.requestAll(index: i, city: city) { [self] vo in
                    
                    // 결과코드가 성공인지 확인
                    guard let heads = vo.RegionMnyFacltStus?[0].head,
                          let code = heads[1].RESULT?.CODE,
                          code == "INFO-000" else {
                        print("code error")
                        self?.hideIndicator()
                        return
                    }
                    
                    // rows 데이터가 있는지 확인
                    guard let rows = vo.RegionMnyFacltStus?[1].row else {
                        print("no data")
                        self?.hideIndicator()
                        return
                    }
                    
                    // 한 데이터씩 확인
                    for row in rows {
                        rowCount += 1
                        self?.checkAddressAndAppend(row: row)
                    }
                    
                    self?.resultCountLabel.text = "\(self?.datas.count ?? 0)개의 검색결과"
                    self?.resultListTableView.reloadData()
                    
                    if rowCount == listTotalCount {
                        self?.showToast("검색을 완료했습니다.", duration: .short)
                        self?.hideIndicator()
                    }
                    
                } failed: {
                    self?.hideIndicator()
                    print("error occurred!")
                }
            }
        } failed: {
            self.hideIndicator()
        }
    }
    
    private func searchShopName(city: String) {
        var rowCount = 0
        
        self.showIndicator("불러오는 중...")
        
        self.viewModel.checkHasData(city: city) { [weak self] vo in
            guard let heads = vo.head,
                  let listTotalCount = heads[0].list_total_count else {
                self?.hideIndicator()
                
                self?.customAlert(title: nil,
                                  message: "\(city)는 더 이상 데이터를 제공하지 않습니다.",
                                  okTitle: "확인",
                                  okHandler: nil,
                                  hasCancel: false)
                return
            }
            let index = listTotalCount / 100 + 1
            
            for i in 1...index {
                self?.viewModel.requestAll(index: i, city: city) { [self] vo in
                    
                    // 결과코드가 성공인지 확인
                    guard let heads = vo.RegionMnyFacltStus?[0].head,
                          let code = heads[1].RESULT?.CODE,
                          code == "INFO-000" else {
                        print("code error")
                        self?.hideIndicator()
                        return
                    }
                    
                    // rows 데이터가 있는지 확인
                    guard let rows = vo.RegionMnyFacltStus?[1].row else {
                        print("no data")
                        self?.hideIndicator()
                        return
                    }
                    
                    // 한 데이터씩 확인
                    for row in rows {
                        rowCount += 1
                        self?.checkShopNameAndAppend(row: row)
                    }
                    
                    self?.resultCountLabel.text = "\(self?.datas.count ?? 0)개의 검색결과"
                    self?.resultListTableView.reloadData()
                    
                    if rowCount == listTotalCount {
                        self?.showToast("검색을 완료했습니다.", duration: .short)
                        self?.hideIndicator()
                    }
                    
                } failed: {
                    self?.hideIndicator()
                    print("error occurred!")
                }
            }
        } failed: {
            self.hideIndicator()
        }
    }
}
