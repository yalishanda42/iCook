//
//  SettingsCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class SettingsCoordinator: TabCoordinator {
    
    private let navController: UINavigationController
    
    private let services: ServiceDependencies
    
    init(in navController: UINavigationController, services: ServiceDependencies) {
        self.navController = navController
        self.services = services
    }
    
    func start() {
        let settingsController = SettingsViewController.instantiateFromStoryboard()
        navController.setViewControllers([settingsController], animated: true)
    }
}
