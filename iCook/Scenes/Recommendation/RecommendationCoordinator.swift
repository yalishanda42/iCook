//
//  RecommendationCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 25.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class RecommendationCoordinator: Coordinator {
    
    private var child: Coordinator?
    
    private let navigationController: UINavigationController
    private let services: ServiceDependencies
    
    private lazy var viewController: RecommendationViewController = {
        let result = RecommendationViewController.instantiateFromStoryboard()
        result.viewModel = viewModel
        return result
    }()
    
    private lazy var viewModel: RecommendationViewModel = {
        let result = RecommendationViewModel()
        result.coordinatorDelegate = self
        return result
    }()
    
    init(in navigationController: UINavigationController, services: ServiceDependencies) {
        self.navigationController = navigationController
        self.services = services
    }
    
    func start() {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
}

extension RecommendationCoordinator: RecommendationViewModelCoordinatorDelegate {
    func generateDishRecommendation() {
        // TEST
        let dishCoordinator = DishCoordinator(in: viewController, services: services, dishId: 1)
        child = dishCoordinator
        dishCoordinator.start()
    }
}
