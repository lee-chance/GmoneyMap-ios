//
//  AppInfoPopupViewController.swift
//  gmoneymap
//
//  Created by HelloDigital on 2021/07/13.
//

import Foundation

class AppInfoPopupViewController: BasePopupViewController {
    
    @IBAction func showTermsAndConditions(_ sender: DynamicUIButton) {
        // TODO: 개인정보처리방침 연결하기
        print("showTermsAndConditions")
    }
    
    @IBAction func dismissButton(_ sender: DynamicUIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
