//
//  AppDelegate.swift
//  MySakeNote
//
//  Created by 岩渕真未 on 2020/12/07.
//  Copyright © 2020 岩渕真未. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabBarController: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 255/255)
        UITabBar.appearance().unselectedItemTintColor = .gray
        UITabBar.appearance().barTintColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 255/255)
        UITabBar.appearance().isTranslucent = false


        var viewControllers: [UIViewController] = []
        
        let mySake =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toMysake")
        mySake.tabBarItem = UITabBarItem(title: "マイ酒", image: UIImage(named: "star"), tag: 0)
        viewControllers.append(mySake)

        let shuzou = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toShuzou")
        shuzou.tabBarItem = UITabBarItem(title: "酒造検索", image: UIImage(named: "shop"), tag: 2)
        viewControllers.append(shuzou)

        let setting = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toSetting")
        setting.tabBarItem = UITabBarItem(title: "設定", image: UIImage(named: "setting"), tag: 3)
        viewControllers.append(setting)

        tabBarController = UITabBarController()
        viewControllers = viewControllers.map {
            UINavigationController(rootViewController: $0)
        }
        tabBarController?.setViewControllers(viewControllers, animated: false)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        self.window!.makeKeyAndVisible()

        return true
    }

    // MARK: UISceneSession Lifecycle

    
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
    

}


