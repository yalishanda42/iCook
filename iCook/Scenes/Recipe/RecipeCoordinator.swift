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
    private let recipeId: Int
    
    private lazy var viewController: RecipeViewController = {
        let result = RecipeViewController.instantiateFromStoryboard()
        result.viewModel = viewModel
        return result
    }()
    
    private lazy var viewModel = RecipeViewModel(
        recipeId: recipeId,
        recipeService: services.recipeService
    )
    
    init(in navigationController: UINavigationController, services: ServiceDependencies, recipeId: Int) {
        self.navigationController = navigationController
        self.services = services
        self.recipeId = recipeId
    }
    
    func start() {
        navigationController.pushViewController(viewController, animated: true)
    }
}
