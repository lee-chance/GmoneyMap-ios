//
//  DownloadView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/14.
//

import UIKit

class DownloadView: BaseViewWithXIB {
    
    @IBOutlet weak var selectedCity: BottomPickerViewTextField!
    @IBOutlet weak var downloadedCityListTableView: UITableView!
    
    var indicator = UIAlertController()
    
    let viewModel = SearchViewModel()
    let cityList = GMapDefine.City.allCases
    var downloadedCityList = Array(GMapManager.shared.downloadedDatas.keys)
    
    override func setupView() {
        super.setupView()
        
        downloadedCityListTableView.delegate = self
        downloadedCityListTableView.dataSource = self
        selectedCity.tintColor = .clear
        createPickerView()
        dismissPickerView()
    }
    
    private func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        selectedCity.inputView = pickerView
    }
    
    private func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.dismiss))
        toolBar.setItems([space, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        selectedCity.inputAccessoryView = toolBar
    }
    
    @objc func dismiss() {
        selectedCity.endEditing(true)
    }
    
    private func showIndicator(_ message: String, tapToDismiss: Bool = false) {
        indicator = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        indicator.view.addSubview(loadingIndicator)
        parentVC.present(indicator, animated: true)
    }
    
    private func downloadData(city: String) {
        var dataModels: [DataModel] = []
        
        self.showIndicator("불러오는 중...")
        
        self.viewModel.checkHasData(city: city) { [weak self] vo in
            guard let heads = vo.head,
                  let listTotalCount = heads[0].list_total_count else {
                self?.parentVC.hideIndicator()
                
                self?.parentVC.customAlert(title: nil,
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
                        self?.parentVC.hideIndicator()
                        return
                    }

                    // rows 데이터가 있는지 확인
                    guard let rows = vo.RegionMnyFacltStus?[1].row else {
                        print("no data")
                        self?.parentVC.hideIndicator()
                        return
                    }

                    // 한 데이터씩 확인
                    for row in rows {
                        let shopName = row.shopName
                        let category = row.categoryName
                        let roadAddress = row.roadAddress
                        let locationAddress = row.locationAddress
                        let telNumber = row.telNumber
                        let latitude = row.latitude
                        let longitude = row.longitude
                        let dataModel = DataModel(CMPNM_NM: shopName, INDUTYPE_NM: category, REFINE_ROADNM_ADDR: roadAddress, REFINE_LOTNO_ADDR: locationAddress, TELNO: telNumber, REFINE_WGS84_LAT: latitude, REFINE_WGS84_LOGT: longitude)
                        dataModels.append(dataModel)
                        if dataModels.count != 0 {
                            self?.indicator.message = "\(dataModels.count*100/listTotalCount)%\n\(dataModels.count)개의 데이터 저장중..."
                        }
                        if dataModels.count == listTotalCount {
                            self?.parentVC.showToast("다운로드를 완료했습니다.", duration: .short)
                            self?.parentVC.hideIndicator()
                            
                            GMapManager.shared.downloadedDatas[city] = dataModels
                            
                            self?.downloadedCityList = Array(GMapManager.shared.downloadedDatas.keys)
                            self?.downloadedCityListTableView.reloadData()
                        }
                    }
                } failed: {
                    self?.parentVC.hideIndicator()
                    print("error occurred!")
                }
            }
        } failed: {
            self.parentVC.hideIndicator()
        }
    }
    
    @IBAction func downloadButton(_ sender: UIButton) {
        
        selectedCity.resignFirstResponder()
        
        guard let city = selectedCity.text,
              city != "" else {
            print("지역을 선택해 주세요!")
            return
        }
        
        parentVC.customAlert(title: "데이터 다운로드",
                           message: "\(city) 데이터를 다운로드 할까요?",
                           okTitle: "확인",
                           okHandler: { [weak self] action in
                            self?.downloadData(city: city)
                           },
                           cancelTitle: "취소",
                           cancelHandler: nil)
    }
    
}

extension DownloadView: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityList.count
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityList[row].rawValue
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity.text = cityList[row].rawValue
    }
}

extension DownloadView: UITableViewDelegate, UITableViewDataSource {
    // row when selected : 셀 터치시 회색 표시 없애기
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26.ratioConstant
    }

    // header title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "다운로드한 지역"
    }

    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedCityList.count
    }

    // cell design
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")

        cell.textLabel?.text = downloadedCityList[indexPath.row]

        return cell
    }
}
