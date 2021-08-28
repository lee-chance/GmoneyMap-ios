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
                    print("Data Error!")
                    self.hideIndicator {
                        self.customAlert(title: "불러오기 오류!",
                                         message: "재시도 하거나 데이터를 다시 다운로드 받아주세요.",
                                         okTitle: "확인",
                                         hasCancel: false)
                    }
                    return
                }
                
                // 한 데이터씩 확인
                for row in rows {
                    self.checkShopNameAndAppend(row: row)
                }
                
                self.resultCountLabel.text = "\(self.datas.count)개의 검색결과"
                self.resultListTableView.reloadData()
                self.showToast("검색을 완료했습니다.", duration: .short)
                self.hideIndicator()
            }
        }
    }
    
    private func searchAddressFromDB(city: String) {
        DispatchQueue.main.async {
            if let jsonString = UserDefaults.standard.value(forKey: city) as? String {
                
                guard let data = jsonString.data(using: .utf8),
                      let rows = try? JSONDecoder().decode([RowVO].self, from: data) else {
                    print("Data Error!")
                    self.hideIndicator {
                        self.customAlert(title: "불러오기 오류!",
                                         message: "재시도 하거나 데이터를 다시 다운로드 받아주세요.",
                                         okTitle: "확인",
                                         hasCancel: false)
                    }
                    return
                }
                
                // 한 데이터씩 확인
                for row in rows {
                    self.checkAddressAndAppend(row: row)
                }
                
                self.resultCountLabel.text = "\(self.datas.count)개의 검색결과"
                self.resultListTableView.reloadData()
                self.showToast("검색을 완료했습니다.", duration: .short)
                self.hideIndicator()
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
    
    private func searchAddress(city: String) {
        var rowCount = 0
        
        self.viewModel.checkHasData(city: city, onAction: {
            self.hideIndicator {
                self.customAlert(title: "\(city)는 더 이상 데이터를 제공하지 않습니다.",
                                 okTitle: "확인",
                                 hasCancel: false)
            }
        }, completion: { [weak self] index, listTotalCount in
            for i in 1...index {
                self?.viewModel.requestAll(index: i, city: city, hideIndicator: {
                    self?.hideIndicator()
                }, onAction: { row in
                    rowCount += 1
                    self?.checkAddressAndAppend(row: row)
                }, doneAction: {
                    self?.resultCountLabel.text = "\(self?.datas.count ?? 0)개의 검색결과"
                    self?.resultListTableView.reloadData()
                    
                    if rowCount == listTotalCount {
                        self?.showToast("검색을 완료했습니다.", duration: .short)
                        self?.hideIndicator()
                    }
                }, failed: {
                    self?.hideIndicator()
                    print("requestAll error occurred!")
                })
            }
        }, failed: {
            self.hideIndicator()
            print("checkHasData error occurred!")
        })
    }
    
    private func searchShopName(city: String) {
        var rowCount = 0
        
        viewModel.checkHasData(city: city, onAction: {
            self.hideIndicator {
                self.customAlert(title: "\(city)는 더 이상 데이터를 제공하지 않습니다.",
                                 okTitle: "확인",
                                 hasCancel: false)
            }
        }, completion: { index, listTotalCount in
            for i in 1...index {
                self.viewModel.requestAll(index: i, city: city, hideIndicator: {
                    self.hideIndicator()
                }, onAction: { row in
                    rowCount += 1
                    self.checkShopNameAndAppend(row: row)
                }, doneAction: {
                    self.resultCountLabel.text = "\(self.datas.count)개의 검색결과"
                    self.resultListTableView.reloadData()
                    
                    if rowCount == listTotalCount {
                        self.showToast("검색을 완료했습니다.", duration: .short)
                        self.hideIndicator()
                    }
                }, failed: {
                    self.hideIndicator()
                    print("requestAll error occurred!")
                })
            }
        }, failed: {
            self.hideIndicator()
            print("checkHasData error occurred!")
        })
    }
}
