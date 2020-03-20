//
//  DashboardCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class DashboardCoordinator: TabCoordinator {
    
    let navController: UINavigationController
    
    init(in navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        let dashboardViewController = DashboardViewController.instantiateFromStoryboard()
        
        navController.setViewControllers([dashboardViewController], animated: true)
    }
}
