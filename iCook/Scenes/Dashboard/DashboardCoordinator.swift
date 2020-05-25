//
//  DashboardCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class DashboardCoordinator: TabCoordinator {
    
    weak var switchTabDelegate: TabSwitchable?

    private var child: Coordinator?
    
    private let navController: UINavigationController
    private let services: ServiceDependencies
    
    private lazy var viewModel: DashboardViewModel = {
        let result = DashboardViewModel(
            authenticationService: services.authenticationService,
            dishService: services.dishService
        )
        result.coordinatorDelegate = self
        return result
    }()
    
    private lazy var presentedViewController: DashboardViewController = {
        let result = DashboardViewController.instantiateFromStoryboard()
        result.viewModel = viewModel
        return result
    }()
    
    init(in navController: UINavigationController, services: ServiceDependencies) {
        self.navController = navController
        self.services = services
    }
    
    func start() {
        navController.setViewControllers([presentedViewController], animated: true)
    }
}

extension DashboardCoordinator: DashboardViewModelCoordinatorDelegate {
    func goToLoginScreen(onSuccessfulLogin: @escaping () -> Void) {
        let loginCoordinator = AuthenticateCoordinator(in: presentedViewController, services: services)
        loginCoordinator.onFinish = { [weak self] success in
            guard let self = self else { return }
            guard success else {
                AppDelegate.logger.warning("Unable to login.")
                // TODO: Handle error
                return
            }
            self.child = nil
            if success {
                onSuccessfulLogin()
            }
            // TODO: else?
        }
        child = loginCoordinator
        loginCoordinator.start()
    }
    
    func goToDishScreen(dishId: Int) {
        let dishCoordinator = DishCoordinator(in: presentedViewController, services: services, dishId: dishId)
        child = dishCoordinator
        dishCoordinator.start()
    }
    
    func goToRateRecipesScreen() {
        switchTabDelegate?.switchToSearch()
    }
    
    func goToRecommendationGenerationScreen() {
        let recommendationCoordinator = RecommendationCoordinator(in: navController, services: services)
        child = recommendationCoordinator
        recommendationCoordinator.start()
    }
}
