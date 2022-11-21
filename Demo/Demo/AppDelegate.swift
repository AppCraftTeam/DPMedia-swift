//
//  AppDelegate.swift
//  Demo
//
//  Created by Дмитрий Поляков on 20.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc = ViewController()
        let nc = UINavigationController(rootViewController: vc)
        
        self.window = .init()
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
        return true
    }


}

