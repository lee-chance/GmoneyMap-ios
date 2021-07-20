//
//  AppInfoPopupViewController.swift
//  gmoneymap
//
//  Created by HelloDigital on 2021/07/13.
//

import Foundation

class AppInfoPopupViewController: BasePopupViewController {
    
    @IBAction func showTermsAndConditions(_ sender: DynamicUIButton) {
        // FIXME: 링크 정비 필요
        let privacyPolicy = "https://sites.google.com/view/chance-gmoney-privacy-policy/%ED%99%88"
        if let url = URL(string: privacyPolicy) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func dismissButton(_ sender: DynamicUIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
