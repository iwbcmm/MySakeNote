//
//  TabBarController.swift
//  MySakeNote
//
//  Created by 岩渕真未 on 2021/01/15.
//  Copyright © 2021 岩渕真未. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewControllers = [UIViewController]()
        let ViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toMysake")
        ViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        viewControllers.append(ViewController)
        
        let ShuzouViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toShuzou")
        ShuzouViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        viewControllers.append(ShuzouViewController)
        
        let SettingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toSetting")
        SettingViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        viewControllers.append(SettingViewController)
        
        self.viewControllers = viewControllers.map{ UINavigationController(rootViewController: $0) }
        self.setViewControllers(viewControllers, animated: false)
       
    }

}
