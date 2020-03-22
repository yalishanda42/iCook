//
//  AppCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

protocol TabCoordinator: Coordinator {
    init(in: UINavigationController, services: ServiceDependencies)
}

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []

    private var window: UIWindow?
    
    private let services: ServiceDependencies
    
    private lazy var tabBarController: UITabBarController = {
        let result = UITabBarController()
        result.tabBar.tintColor = .deepPurple
        result.viewControllers = []
        return result
    }()
    
    init(in window: UIWindow?, services: ServiceDependencies) {
        self.window = window
        self.services = services
    }
    
    func start() {
        guard let window = window else { return }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
                
        for tab in Tab.allCases {
            let navController = UINavigationController()
            navController.tabBarItem = tab.tabBarItem
            
            var tabControllers = tabBarController.viewControllers ?? []
            tabControllers.append(navController)
            tabBarController.viewControllers = tabControllers
            let coordinator = tab.coordinatorClass.init(in: navController, services: services)
            childCoordinators.append(coordinator)
            coordinator.start()
        }
    }
}

extension AppCoordinator {
    enum Tab: Int, CaseIterable {
        case dashboard = 0
        case browse = 1
        case settings = 2
        
        var tabBarItem: UITabBarItem {
            return UITabBarItem(title: displayName, image: tabBarImage, tag: rawValue)
        }
        
        var displayName: String {
            switch self {
            case .dashboard:
                return "Dashboard"
            case .browse:
                return "Browse"
            case .settings:
                return "Settings"
            }
        }
        
        var tabBarImage: UIImage? {
            let imageName: String
            switch self {
            case .dashboard:
                imageName = "house"
            case .browse:
                imageName = "book"
            case .settings:
                imageName = "gear"
            }
            return UIImage(systemName: imageName)
        }
        
        var coordinatorClass: TabCoordinator.Type {
            switch self {
            case .dashboard:
                return DashboardCoordinator.self
            case .browse:
                return BrowseCoordinator.self
            case .settings:
                return SettingsCoordinator.self
            }
        }
    }
}
