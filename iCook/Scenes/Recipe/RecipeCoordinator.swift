//
//  RecipeCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class RecipeCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let services: ServiceDependencies
    
    private lazy var viewController: RecipeViewController = {
        let result = RecipeViewController.instantiateFromStoryboard()
        result.viewModel = viewModel
        return result
    }()
    
    private lazy var viewModel: RecipeViewModel = {
        let result = RecipeViewModel()
        return result
    }()
    
    init(in navigationController: UINavigationController, services: ServiceDependencies) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func start() {
        navigationController.pushViewController(viewController, animated: true)
    }
}
