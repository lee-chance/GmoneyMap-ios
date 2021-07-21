//
//  SearchView.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/14.
//

import UIKit

import DropDown

class SearchView: BaseViewWithXIB {
    
    @IBOutlet var selectedCity: BottomPickerViewTextField!
    @IBOutlet var searchTypeButton: UIButton!
    @IBOutlet var searchType: UILabel!
    @IBOutlet var searchTextField: UITextField!
    
    let dropDown = DropDown()
    let cityList = GMapDefine.City.allCases
    
    override func setupView() {
        super.setupView()
        
        // 바깥클릭으로 닫기
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        tap.cancelsTouchesInView = false // table cell이 클릭 안되는 것 방지
        view?.superview?.isUserInteractionEnabled = true
        view?.superview?.addGestureRecognizer(tap)
        
        selectedCity.tintColor = .clear
        createPickerView()
        dismissPickerView()
        
        dropDown.dataSource = ["상호명", "주소"]
        dropDown.anchorView = searchTypeButton
        dropDown.bottomOffset = CGPoint(x: 0, y: dropDown.anchorView?.plainView.bounds.height ?? 0)
        dropDown.selectionAction = { [unowned self] index, item in
            print("\(item), \(index)")
            searchType.text = item
            dropDown.clearSelection()
        }
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
        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        selectedCity.resignFirstResponder()
        searchTextField.resignFirstResponder()
    }
    
    private func search() {
        guard let city = selectedCity.text,
              city != "" else {
            print("지역을 선택해 주세요!")
            return
        }
        let type = searchType.text!
        let keyword = searchTextField.text!
        
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        
        guard let vc = UIViewController.instantiate(viewController: ResultViewController.rawString, in: .Main) as? ResultViewController else {
            return
        }
        
        vc.loadViewIfNeeded()
        vc.searchKeyword = (city, type, keyword)
        rootVC.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            dropDown.show()
        case 102:
            dismissKeyboard()
            search()
        default: break
        }
    }
    
}

extension SearchView: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
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
