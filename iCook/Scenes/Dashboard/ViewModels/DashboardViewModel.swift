//
//  DashboardViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

protocol DashboardViewModelCoordinatorDelegate: AnyObject {
    func goToLoginScreen(onSuccessfulLogin: @escaping () -> Void)
    func goToDishScreen(dishId: Int)
}

class DashboardViewModel {
    
    weak var coordinatorDelegate: DashboardViewModelCoordinatorDelegate?
    
    private let authenticationService: AuthenticationService
    private let dishService: DishService
    
    init(authenticationService: AuthenticationService, dishService: DishService) {
        self.authenticationService = authenticationService
        self.dishService = dishService
    }
    
    func quickRecommendationCommand() {
        guard authenticationService.isAuthenticated else {
            authenticate()
            return
        }
        showQuickRecommendation()
    }
}

// MARK: - Helpers

private extension DashboardViewModel {
    func authenticate() {
        coordinatorDelegate?.goToLoginScreen() { [weak self] in
            self?.quickRecommendationCommand()
        }
    }
    
    func showQuickRecommendation() {
        dishService.generateNewQuickRandomDishSuggestion { [weak self] dishId in
            self?.coordinatorDelegate?.goToDishScreen(dishId: dishId)
        }
    }
}
