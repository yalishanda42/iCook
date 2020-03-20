//
//  AppCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    var childs: [Coordinator] = []
    
    lazy var apiService: APIService = TestAPIService()
    
    init(in window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        guard let window = window else { return }
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor(named: "accent-darker")
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        let navControllerOne = UINavigationController()
        navControllerOne.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "house"), tag: 0)
        let navControllerTwo = UINavigationController()
        navControllerTwo.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "book"), tag: 1)
        let navControllerThree = UINavigationController()
        navControllerThree.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)

        tabBarController.viewControllers = [navControllerOne, navControllerTwo, navControllerThree]
        
        let dashboardCoordinator = DashboardCoordinator(in: navControllerOne)
        childs.append(dashboardCoordinator)
        dashboardCoordinator.start()
        let browseCoordinator = BrowseCoordinator(in: navControllerTwo)
        childs.append(browseCoordinator)
        browseCoordinator.start()
        let settingsCoordinator = SettingsCoordinator(in: navControllerThree)
        childs.append(settingsCoordinator)
        settingsCoordinator.start()
    }
}
