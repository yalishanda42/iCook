//
//  DashboardViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

protocol DashboardViewModelCoordinatorDelegate: AnyObject {
    func goToLoginScreen(onSuccessfulLogin: @escaping () -> Void)
    func goToDishScreen(dishId: Int)
}

class DashboardViewModel {
    
    weak var coordinatorDelegate: DashboardViewModelCoordinatorDelegate?
    
    private let disposeBag = DisposeBag()
    
    private let authenticationService: AuthenticationService
    private let dishService: DishService
    
    init(authenticationService: AuthenticationService, dishService: DishService) {
        self.authenticationService = authenticationService
        self.dishService = dishService
    }
    
    func quickRecommendationCommand() {
        guard authenticationService.isCurrentlyAuthenticated else {
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
        dishService.generateNewQuickRandomDishSuggestion()
            .subscribe(
                onNext: { [weak self] dishId in
                    self?.coordinatorDelegate?.goToDishScreen(dishId: dishId)
                }, onError: { error in
                    // TODO: Handle error.
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
