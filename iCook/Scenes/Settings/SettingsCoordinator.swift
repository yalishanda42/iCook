//
//  SettingsCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
    
    let navController: UINavigationController
    
    init(in navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        let settingsController = SettingsViewController.instantiateFromStoryboard()
        navController.setViewControllers([settingsController], animated: true)
    }
}
