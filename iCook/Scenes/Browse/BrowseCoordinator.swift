//
//  BrowseCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class BrowseCoordinator: TabCoordinator {
    
    let navController: UINavigationController
    
    init(in navController: UINavigationController) {
        self.navController = navController
    }
    
    func start() {
        let browseController = BrowseViewController.instantiateFromStoryboard()
        navController.setViewControllers([browseController], animated: true)
    }
}
