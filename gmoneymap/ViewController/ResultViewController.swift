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
        showIndicator("불러오는 중...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let selectedCity = searchKeyword.0
        let type = searchKeyword.1
        
        if GMapManager.shared.downloadedCityList.contains(selectedCity) {
            searchThroughLocalDB(city: selectedCity, type: type)
        } else {
            searchThroughNetwork(city: selectedCity, type: type)
        }
    }
    
    private func setup() {
        resultListTableView.delegate = self
        resultListTableView.dataSource = self
        statusBarHeight.constant = Screen.statusBar
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .fullScreen
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
