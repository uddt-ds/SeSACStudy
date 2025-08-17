//
//  TabBarController.swift
//  Picknic
//
//  Created by Lee on 8/15/25.
//

import UIKit

final class TabBarController: UITabBarController {

    private let firstVC = TopicVC()
    private let secondVC = VideoVC()
    private let thirdVC = SearchPhotoVC()
    private let fourthVC = VideoVC()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()

        viewControllers = setupNav()
        setViewControllers(viewControllers, animated: true)
    }


    //TODO: CustomTabBar로 변경 필요. 이미지가 가운데로 정렬이 잘 안되는 상황
    private func setupTabBar() {
        firstVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "chart.line.uptrend.xyaxis"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "play.laptopcomputer"), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 2)
        fourthVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), tag: 3)
    }

    private func setupNav() -> [UIViewController] {
        let firstVCNav = UINavigationController(rootViewController: firstVC)
        let thirdVCNav = UINavigationController(rootViewController: thirdVC)

        return [firstVCNav, secondVC, thirdVCNav, fourthVC]
    }
}
