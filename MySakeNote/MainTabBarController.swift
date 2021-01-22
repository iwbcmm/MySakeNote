//
//  MainTabBarController.swift
//  MySakeNote
//
//  Created by 岩渕真未 on 2021/01/18.
//  Copyright © 2021 岩渕真未. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 0/255, blue: 139/255, alpha: 255/255)
               UITabBar.appearance().unselectedItemTintColor = .gray
               UITabBar.appearance().barTintColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 255/255)
               UITabBar.appearance().isTranslucent = false


               var viewControllers: [UIViewController] = []
               
               let mySake =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toMysake")
               mySake.tabBarItem = UITabBarItem(title: "マイ酒", image: UIImage(named: "star"), tag: 0)
               viewControllers.append(mySake)

               let shuzou = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toShuzou")
               shuzou.tabBarItem = UITabBarItem(title: "酒造", image: UIImage(named: "shop"), tag: 1)
               viewControllers.append(shuzou)

               let setting = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toSetting")
               setting.tabBarItem = UITabBarItem(title: "設定", image: UIImage(named: "setting"), tag: 2)
               viewControllers.append(setting)

               viewControllers = viewControllers.map {
                   UINavigationController(rootViewController: $0)
               }
               tabBarController?.setViewControllers(viewControllers, animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
