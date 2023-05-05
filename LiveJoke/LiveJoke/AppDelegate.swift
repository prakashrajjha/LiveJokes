//
//  AppDelegate.swift
//  LiveJoke
//
//  Created by Prakash Raj on 06/05/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppManager.performLaunchActionFor(application: application, launchOptions: launchOptions)
        return true
    }
}

class AppManager {
    class var appDel: AppDelegate? { return UIApplication.shared.delegate as? AppDelegate }
    class var appWindow: UIWindow? { return AppManager.appDel?.window }
        
    class func performLaunchActionFor(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
    }
}

