//
//  BottomSheetContainerViewController.swift
//  BottomSheetTest
//
//  Created by cslee on 2021/06/10.
//

/**
 HOW TO USE:
 1. 바탕이 될 ContentViewController 생성
 2. 하단 시트가 될 BottomSheetViewController 생성
 3. 컨테이너가 될 ContainerViewController 생성 (아무 기능이 없다)
 4. bottomSheetConfiguration 설정
  - height: 하단 시트의 최대 높이
  - initialOffset: 하단 시트의 최소 높이, 초기 높이
 5. 코드 작성
 ex)
     ContainerViewController(
         contentViewController: ContentViewController(),
         bottomSheetViewController: vc as! BottomSheetViewController, // vc는 스토리보드에서 가져온 객체
         bottomSheetConfiguration: .init(
             height: UIScreen.main.bounds.height - window!.safeAreaInsets.top,
             initialOffset: 60 + window!.safeAreaInsets.bottom
         )
     )
 */

import UIKit

open class BottomSheetContainerViewController<
    Content: UIViewController,
    BottomSheet: UIViewController
>: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Initialzation
    /// Children
    let contentViewController: Content
    let bottomSheetViewController: BottomSheet
    
    /// Configuration
    private let configuration: BottomSheetConfiguration
    
    public struct BottomSheetConfiguration {
        let height: CGFloat
        let initialOffset: CGFloat
    }
    
    /// State
    var state: BottomSheetState = .initial
    
    public enum BottomSheetState {
        case none
        case initial
        case full
    }
    
    /// initialzation
    public init(contentViewController: Content,
                bottomSheetViewController: BottomSheet,
                bottomSheetConfiguration: BottomSheetConfiguration) {
        
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        self.configuration = bottomSheetConfiguration
        
        super.init(nibName: nil, bundle: nil)
        
        self.setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UIGestureRecognizer
    /// initialzation UIPanGestureRecognizer
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.delegate = self
        pan.addTarget(self, action: #selector(handlePan))
        return pan
    }()
    
    /// Top Constraint
    private var topConstraint = NSLayoutConstraint()
    
    /// UIGestureRecognizer Delegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /// handler when scroll bottom sheet view
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: bottomSheetViewController.view)
        let velocity = sender.velocity(in: bottomSheetViewController.view)
        
        let yTranslation = translation.y
        
        switch sender.state {
        case .began, .changed:
            switch self.state {
            case .full:
                guard yTranslation > 0 else { return }
                
                topConstraint.constant = -(configuration.height - yTranslation)
                
                self.view.layoutIfNeeded()
            case .initial:
                let newConstant = -(configuration.initialOffset - yTranslation)
                
                guard yTranslation < 0 else { return }
                
                guard newConstant.magnitude < configuration.height else {
                    self.showBottomSheet()
                    return
                }
                
                topConstraint.constant = newConstant
                
                self.view.layoutIfNeeded()
            default: break
            }
        case .ended:
            switch self.state {
            case .full:
                if yTranslation >= configuration.height / 2 || velocity.y > 1000 {
                    self.initBottomSheet()
                } else {
                    self.showBottomSheet()
                }
            case .initial:
                if -yTranslation >= configuration.height / 2 || velocity.y < -1000 {
                    self.showBottomSheet()
                } else {
                    self.initBottomSheet()
                }
            default: break
            }
        case .failed:
            switch self.state {
            case .full: self.showBottomSheet()
            case .initial: self.initBottomSheet()
            default: break
            }
        default: break
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addChild(contentViewController)
        self.addChild(bottomSheetViewController)
        
        self.view.addSubview(contentViewController.view)
        self.view.addSubview(bottomSheetViewController.view)
        
        bottomSheetViewController.view.addGestureRecognizer(panGesture)
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            contentViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            contentViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        contentViewController.didMove(toParent: self)
        
        topConstraint = bottomSheetViewController.view.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -configuration.initialOffset)
        
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.heightAnchor.constraint(equalTo: contentViewController.view.heightAnchor),
            bottomSheetViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bottomSheetViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            topConstraint
        ])
        
        bottomSheetViewController.didMove(toParent: self)
    }
    
    // MARK: - Bottom Sheet Actions
    /// showBottomSheet
    public func showBottomSheet(animated: Bool = true) {
        self.topConstraint.constant = -configuration.height
        
        if animated {
            animate { _ in
                self.state = .full
            }
        } else {
            self.view.layoutIfNeeded()
            self.state = .full
        }
    }
    
    /// showBottomSheetClosure for external
    public func showBottomSheetClosure() -> ()->Void {
        return { [weak self] in
            self?.topConstraint.constant = -(self?.configuration.height)!
            self?.animate { _ in
                self?.state = .full
            }
        }
    }
    
    /// hideBottomSheet
    public func initBottomSheet(animated: Bool = true) {
        self.topConstraint.constant = -configuration.initialOffset
        
        if animated {
            animate { _ in
                self.state = .initial
            }
        } else {
            self.view.layoutIfNeeded()
            self.state = .initial
        }
    }
    
    /// hideBottomSheetClosure for external
    public func initBottomSheetClosure() -> ()->Void {
        return { [weak self] in
            self?.topConstraint.constant = -(self?.configuration.initialOffset)!
            self?.animate { _ in
                self?.state = .initial
            }
        }
    }
    
    /// hideBottomSheetClosure for external
    public func hideBottomSheetClosure() -> ()->Void {
        return { [weak self] in
            self?.topConstraint.constant = 0
            self?.animate { _ in
                self?.state = .none
            }
        }
    }
    
    private func animate(completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: { self.view.layoutIfNeeded() },
                       completion: completion)
    }
    
}
