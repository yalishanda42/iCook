//
//  BrowseCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class BrowseCoordinator: TabCoordinator {
    
    private let navController: UINavigationController
    private let services: ServiceDependencies
    
    private lazy var browseController: BrowseViewController = {
        let result = BrowseViewController.instantiateFromStoryboard()
        result.viewModel = browseViewModel
        return result
    }()
    
    private lazy var browseViewModel: BrowseViewModel = {
        let result = BrowseViewModel(searchService: services.searchService)
        return result
    }()
    
    init(in navController: UINavigationController, services: ServiceDependencies) {
        self.navController = navController
        self.services = services
    }
    
    func start() {
        navController.setViewControllers([browseController], animated: true)
    }
}
