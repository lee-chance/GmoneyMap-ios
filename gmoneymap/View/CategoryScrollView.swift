//
//  CategoryScrollView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/02.
//

import UIKit

class CategoryScrollView: BaseViewWithXIB {

    @IBOutlet var stackView: UIStackView!
    
    let categoryList = GMapDefine.Category.allCases
    let viewModel = SearchViewModel()
    
    var setCircle: ((Int)->Void)?
    var setNewMarker: ((RowVO)->Void)?
    
    override func setupView() {
        super.setupView()
        
        addPaddingView(width: 16.ratioConstant)

        for (i, category) in categoryList.enumerated() {
            let cell = CategoryViewCell()
            cell.tag = 100 + i
            cell.setupCell(category: category.rawValue)
            cell.onClick = {
                self.resetCells()
                let c = self.viewWithTag(cell.tag) as? CategoryViewCell
                c?.parentView.backgroundColor = .appColor(.PrimaryLighter)
                c?.categoryName.textColor = .white
                
                // TODO: 프로그래스바, 데이터 초기화(?)
                var rowCount = 0
                let radius = 300
                
                // FIXME: GMapManager.shared.selectedCity nil값 처리
                self.viewModel.checkHasData(city: GMapManager.shared.selectedCity!) { [weak self] vo in
                    guard let heads = vo.head,
                          let listTotalCount = heads[0].list_total_count else {
                        return
                    }
                    let index = listTotalCount / 100 + 1

                    // TODO: Circle 생성
                    self?.setCircle?(radius)
                    
                    for i in 1...index {
                        self?.viewModel.requestAll(index: i, city: GMapManager.shared.selectedCity!) { vo in

                            // 결과코드가 성공인지 확인
                            guard let heads = vo.RegionMnyFacltStus?[0].head,
                                  let code = heads[1].RESULT?.CODE,
                                  code == "INFO-000" else {
                                print("메롱") // FIXME: Fix me here
                                return
                            }

                            // rows 데이터가 있는지 확인
                            guard let rows = vo.RegionMnyFacltStus?[1].row else {
                                print("no data")
                                return
                            }

                            // 한 데이터씩 확인
                            for row in rows {
                                rowCount += 1
                                // 좌표값 확인
                                if let latString = row.REFINE_WGS84_LAT,
                                   let lonString = row.REFINE_WGS84_LOGT,
                                   let lat = Double(latString),
                                   let lon = Double(lonString) {
                                    // 내 위치와 거리 비교
                                    let distance = Int(sqrt(pow(lat-GMapManager.shared.latitude!, 2) + pow(lon-GMapManager.shared.longitude!, 2)) * 100000)
                                    // 거리가 radius 이내에 있는 값만 마커표시
                                    if distance < radius {
                                        self?.setNewMarker?(row)
                                    }
                                }
                                if rowCount == listTotalCount {
                                    print("dismiss") // TODO: 프로그래스바
                                    print("검색을 완료했습니다.")
                                }
                            }
                        } failed: {
                            print("error occurred!")
                        }
                    }
                }
            }
            stackView.addArrangedSubview(cell)
        }
        
        addPaddingView(width: 16.ratioConstant)
    }
    
    private func addPaddingView(width: CGFloat) {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        stackView.addArrangedSubview(view)
    }
    
    private func resetCells() {
        for i in 0..<categoryList.count {
            let tag = 100 + i
            let cell = viewWithTag(tag) as? CategoryViewCell
            cell?.parentView.backgroundColor = .white
            cell?.categoryName.textColor = .black
        }
    }
    
}
