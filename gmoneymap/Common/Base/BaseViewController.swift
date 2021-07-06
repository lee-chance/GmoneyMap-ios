//
//  BaseViewController.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/26.
//

import Foundation

class BaseViewController: UIViewController {
    
    // MARK: - Alert
    func customAlert(title: String? = "",
                     message: String? = "",
                     okTitle: String = "확인",
                     okHandler: ((UIAlertAction)->Void)? = nil,
                     hasCancel: Bool = true,
                     cancelTitle: String = "취소",
                     cancelHandler: ((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
        alert.addAction(okAction)
        if hasCancel {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
            alert.addAction(cancelAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - indicator
    func showIndicator(_ message: String, tapToDismiss: Bool = false) {
        let indicator = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();
        indicator.view.addSubview(loadingIndicator)
        present(indicator, animated: true) {
            if tapToDismiss {
                // 바깥클릭으로 닫기
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                indicator.view.superview?.isUserInteractionEnabled = true
                indicator.view.superview?.addGestureRecognizer(tap)
            }
        }
    }
    
    func hideIndicator() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didTappedOutside(_ sender: UITapGestureRecognizer) {
        hideIndicator()
    }
    
    // MARK: - Toast
    enum ToastInterval: Double {
        case short = 5.0
        case long = 10.0
    }
    
    func showToast(_ message: String, duration: ToastInterval) {
        let textWidth = (message as NSString).size(withAttributes: [NSAttributedString.Key.font : UILabel().font!]).width
        let labelWidth = textWidth + 30 // 좌우 15 마진
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - labelWidth/2,
                                               y: self.view.frame.size.height - Screen.bottomSafeArea - 100.ratioConstant,
                                               width: labelWidth,
                                               height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: duration.rawValue,
                       delay: 0.1,
                       options: .curveEaseIn,
                       animations: { toastLabel.alpha = 0.0 },
                       completion: { (isCompleted) in
                        toastLabel.removeFromSuperview()
                       })
    }
    
}
