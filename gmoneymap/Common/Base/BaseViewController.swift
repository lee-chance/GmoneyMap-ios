//
//  BaseViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/26.
//

import Foundation

class BaseViewController: UIViewController {
    //Toast Message
    //How To Use : showToast(controller: self, message : "This is a test", seconds: 2.0)
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
