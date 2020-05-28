//
//  RecipeCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class RecipeCoordinator: Coordinator {
    
    private var child: Coordinator?
    
    private let navigationController: UINavigationController
    private let services: ServiceDependencies
    private let viewModelMode: RecipeViewModel.Mode
    
    private lazy var viewController: RecipeViewController = {
        let result = RecipeViewController.instantiateFromStoryboard()
        result.viewModel = viewModel
        return result
    }()
    
    private lazy var viewModel: RecipeViewModel = {
        let result = RecipeViewModel(withMode: viewModelMode, recipeService: services.recipeService)
        result.coordinatorDelegate = self
        return result
    }()
    
    init(in navigationController: UINavigationController, services: ServiceDependencies, viewModelMode: RecipeViewModel.Mode) {
        self.navigationController = navigationController
        self.services = services
        self.viewModelMode = viewModelMode
    }
    
    func start() {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
}

extension RecipeCoordinator: RecipeViewModelCoordinatorDelegate {
    func goToComments() {
        let coordinator = CommentsCoordinator(in: viewController, services: services)
        child = coordinator
        coordinator.start()
    }
    
    func goToProducts() {
        let coordinator = ProductsCoordinator(in: viewController, services: services)
        child = coordinator
        coordinator.start()
    }
}
