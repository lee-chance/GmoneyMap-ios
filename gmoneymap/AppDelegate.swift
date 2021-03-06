//
//  AppDelegate.swift
//  gmoneymap
//
//  Created by Changsu Lee on 2021/05/31.
//

import UIKit

import Firebase
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        KakaoSDKCommon.initSDK(appKey: "e2cca786ee8abe52f4210a35aebd0a7e")
        
        let mapVC = UIViewController.instantiate(viewController: MapViewController.rawString, in: .Main)
        let menuVC = UIViewController.instantiate(viewController: BottomSheetViewController.rawString, in: .Main)
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = ContainerViewController(
            contentViewController: mapVC as! MapViewController,
            bottomSheetViewController: menuVC as! BottomSheetViewController,
            bottomSheetConfiguration: .init(
                height: Screen.height - Screen.statusBar,
                initialOffset: Screen.bottomSafeArea + 60.ratioConstant
            )
        )
        
        return true
    }


}

