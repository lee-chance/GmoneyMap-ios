//
//  ResultViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/07/21.
//

import Foundation

class ResultViewController: BaseViewController {
    
    @IBOutlet weak var resultCountLabel: DynamicUILabel!
    @IBOutlet weak var resultListTableView: UITableView!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    let viewModel = SearchViewModel()
    var searchKeyword = ("", "", "")
    var datas = [RowVO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        datas = []
        
        // TODO: 데이터베이스에서 가져오기 구현
        let type = searchKeyword.1
        switch type {
        case "상호명":
            searchShopName()
        case "주소":
            searchAddress()
        default: break
        }
    }
    
    private func setup() {
        resultListTableView.delegate = self
        resultListTableView.dataSource = self
        statusBarHeight.constant = Screen.statusBar
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .fullScreen
    }
    
    // FIXME: 클린코드 필요..ㅠ
    private func searchAddress() {
        let city = searchKeyword.0
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
            
            DispatchQueue.global().async {
                for i in 1...index {
                    self?.viewModel.requestAll(index: i, city: city) { [self] vo in
                        
                        // 결과코드가 성공인지 확인
                        guard let heads = vo.RegionMnyFacltStus?[0].head,
                              let code = heads[1].RESULT?.CODE,
                              code == "INFO-000" else {
                            print("code error")
                            DispatchQueue.main.async {
                                self?.hideIndicator()
                            }
                            return
                        }
                        
                        // rows 데이터가 있는지 확인
                        guard let rows = vo.RegionMnyFacltStus?[1].row else {
                            print("no data")
                            DispatchQueue.main.async {
                                self?.hideIndicator()
                            }
                            return
                        }
                        
                        // 한 데이터씩 확인
                        for row in rows {
                            rowCount += 1
                            self?.checkAddressAndAppend(row: row)
                            
                            if self?.datas.count != 0 {
                                DispatchQueue.main.async {
                                    self?.resultCountLabel.text = "\(self!.datas.count)개의 검색결과"
                                    
                                    self?.resultListTableView.reloadData()
                                }
                            }
                            if rowCount == listTotalCount {
                                DispatchQueue.main.async {
                                    self?.showToast("검색을 완료했습니다.", duration: .short)
                                    self?.hideIndicator()
                                    
                                    self?.resultListTableView.reloadData()
                                }
                            }
                        }
                    } failed: {
                        DispatchQueue.main.async {
                            self?.hideIndicator()
                        }
                        print("error occurred!")
                    }
                }
            }
        } failed: {
            self.hideIndicator()
        }
    }
    
    private func searchShopName() {
        let city = searchKeyword.0
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
            
            DispatchQueue.global().async {
                for i in 1...index {
                    self?.viewModel.requestAll(index: i, city: city) { [self] vo in
                        
                        // 결과코드가 성공인지 확인
                        guard let heads = vo.RegionMnyFacltStus?[0].head,
                              let code = heads[1].RESULT?.CODE,
                              code == "INFO-000" else {
                            print("code error")
                            DispatchQueue.main.async {
                                self?.hideIndicator()
                            }
                            return
                        }
                        
                        // rows 데이터가 있는지 확인
                        guard let rows = vo.RegionMnyFacltStus?[1].row else {
                            print("no data")
                            DispatchQueue.main.async {
                                self?.hideIndicator()
                            }
                            return
                        }
                        
                        // 한 데이터씩 확인
                        for row in rows {
                            rowCount += 1
                            self?.checkShopNameAndAppend(row: row)
                            
                            if self?.datas.count != 0 {
                                DispatchQueue.main.async {
                                    self?.resultCountLabel.text = "\(self!.datas.count)개의 검색결과"
                                    
                                    self?.resultListTableView.reloadData()
                                }
                            }
                            if rowCount == listTotalCount {
                                DispatchQueue.main.async {
                                    self?.showToast("검색을 완료했습니다.", duration: .short)
                                    self?.hideIndicator()

                                    self?.resultListTableView.reloadData()
                                }
                            }
                        }

                    } failed: {
                        DispatchQueue.main.async {
                            self?.hideIndicator()
                        }
                        print("error occurred!")
                    }
                }
            }
        } failed: {
            self.hideIndicator()
        }
    }
    
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
    
    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultListCell.rawString, for: indexPath) as! ResultListCell
        cell.shopName.text = datas[indexPath.row].shopName ?? "-"
        cell.category.text = datas[indexPath.row].categoryName ?? "-"
        cell.address.text = datas[indexPath.row].roadAddress ?? datas[indexPath.row].locationAddress ?? "-"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        customAlert(title: nil,
                    message: "\(datas[indexPath.row].shopName!)의 위치로 이동할까요?",
                    okTitle: "확인",
                    okHandler: { [weak self] _ in
                        guard let _ = self?.datas[indexPath.row].latitude,
                              let _ = self?.datas[indexPath.row].longitude else {
                            self?.showToast("지도검색을 제공하지 않습니다.", duration: .short)
                            return
                        }
                        // 1. 검색결과화면 닫기
                        self?.dismiss(animated: true, completion: nil)
                        // 2. 바텀시트뷰 닫기
                        guard let rootVC = UIApplication.shared.windows.first?.rootViewController as? ContainerViewController else {
                            return
                        }
                        rootVC.contentViewController.initBottomSheet?()
                        // 3. 검색위치로 이동 및 마커찍기
                        rootVC.contentViewController.search(vo: self!.datas[indexPath.row])
                    })
    }
    
}
