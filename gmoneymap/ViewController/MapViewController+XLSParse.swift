//
//  MapViewController+XLSParse.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/08/29.
//

import Foundation
import CoreXLSX

extension MapViewController {
    
    func setCategoryMap() {
        // 최초 1회 실행
        guard GMapManager.shared.categoryMap == nil else { return }
        
        let filepath = Bundle.main.path(forResource: "shoplist", ofType: "xlsx")!
        guard let file = XLSXFile(filepath: filepath) else {
            fatalError("XLSX file at \(filepath) is corrupted or does not exist")
        }
        
        var map = [String : [String]]()
        var list = [String]()
        
        do {
            for path in try file.parseWorksheetPaths() {
                let worksheet = try file.parseWorksheet(at: path)
                if let sharedStrings = try file.parseSharedStrings() {
                    for i in 1...19 {
                        list = []
                        let columns = worksheet.cells(atColumns: [ColumnReference("\(UnicodeScalar(64+i)!)")!]).filter { $0.value != nil }
                        for column in columns {
                            if let text = column.stringValue(sharedStrings) {
                                list.append(text)
                            } else {
                                let richText = column.richStringValue(sharedStrings)
                                    .compactMap { $0.text }
                                    .reduce("") { $0 + $1 }
                                list.append(richText)
                            }
                        }
                        map["\(i)"] = list
                    }
                }
                GMapManager.shared.categoryMap = map
            }
        } catch {
            print(error)
        }
    }
}
