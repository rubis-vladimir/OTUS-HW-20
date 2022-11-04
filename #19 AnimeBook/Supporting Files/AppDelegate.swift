//
//  AppDelegate.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 21.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        let navigationController = UINavigationController()
        let vc = AnimeListAssembly(navigationController: navigationController).assembly()
        navigationController.viewControllers = [vc]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

