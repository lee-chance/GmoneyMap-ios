//
//  Keyboard.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/06/08.
//

class Keyboard {
    
    private let viewAboveKeyboard: UIView
    private let removeBottomSafeArea: Bool
    
    init(targetView: UIView, removeBottom: Bool = true) {
        self.viewAboveKeyboard = targetView
        self.removeBottomSafeArea = removeBottom
    }
    
    func registerForKeyboardNotifications() {
        // 옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        // 옵저버 등록 해제
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        var bottomSafeArea: CGFloat = 0
        if removeBottomSafeArea {
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}),
                  let root = window.rootViewController else {
                return
            }
            bottomSafeArea = root.view.safeAreaInsets.bottom
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.viewAboveKeyboard.transform = CGAffineTransform(translationX: 0, y: bottomSafeArea - keyboardSize.height)
            })
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        viewAboveKeyboard.transform = .identity
    }
    
}
