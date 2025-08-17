//
//  TabBarController.swift
//  MVVMBasic
//
//  Created by Lee on 8/8/25.
//

import UIKit

final class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupTabBar()
        tabBar.isHidden = true
    }

    private func setupTabBar() {
        let vc = MBTIViewController()
        vc.tabBarItem.title = "PROFILE"
        vc.tabBarItem.image = UIImage(systemName: "person")
        vc.tabBarItem.selectedImage = UIImage(systemName: "person.fill")

        setViewControllers([vc], animated: true)
    }

    private func setupNav() {
        navigationItem.title = "PROFILE SETTING"
        navigationItem.backButtonTitle = ""
    }
}


