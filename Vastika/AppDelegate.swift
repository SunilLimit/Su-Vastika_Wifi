//
//  AppDelegate.swift
//  Vastika
//
//  Created by Mac on 13/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    var storyboard = UIStoryboard()
    var isFrom : String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let userActive = UserDefaults.standard.object(forKey: "isLogin") as? Bool
        if userActive == false || userActive == nil
        {
            self.setRootNavigation()
        }
        else
        {
            self.setHomeVieew()
        }
        // Override point for customization after application launch.
        return true
    }
    
    func setRootNavigation()
    {
        let navRoot = self.storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
        self.window?.rootViewController = navRoot
    }

    func setHomeVieew()
    {
       
        let navRoot = self.storyboard.instantiateViewController(withIdentifier: "OptionNav")
        self.window?.rootViewController = navRoot
        
//        let navRoot = self.storyboard.instantiateViewController(withIdentifier: "HomeNavigation")
//        self.window?.rootViewController = navRoot
    }
}

extension UINavigationController {

func setStatusBar(backgroundColor: UIColor) {
    let statusBarFrame: CGRect
    if #available(iOS 13.0, *) {
        statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
    } else {
        statusBarFrame = UIApplication.shared.statusBarFrame
    }
    let statusBarView = UIView(frame: statusBarFrame)
    statusBarView.backgroundColor = backgroundColor
    view.addSubview(statusBarView)
}

}
