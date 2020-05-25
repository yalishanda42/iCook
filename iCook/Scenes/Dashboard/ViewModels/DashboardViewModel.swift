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
    func goToRateRecipesScreen()
    func goToRecommendationGenerationScreen()
}

class DashboardViewModel: SceneViewModel {
    
    weak var coordinatorDelegate: DashboardViewModelCoordinatorDelegate?
        
    private let authenticationService: AuthenticationService
    private let dishService: DishService
    
    init(authenticationService: AuthenticationService, dishService: DishService) {
        self.authenticationService = authenticationService
        self.dishService = dishService
        super.init()
    }
}

// MARK: - IO Transformable
extension DashboardViewModel: IOTransformable {
    struct Input {
        let quickRecommendationButtonTap: Observable<Void>
        let regularRecommendationButtonTap: Observable<Void>
        let rateRecipesButtonTap: Observable<Void>
    }
    
    func transform(_ input: Input) -> Void {
        input.quickRecommendationButtonTap
            .withLatestFrom(authenticationService.isAuthenticated)
            .subscribe(onNext: { [unowned self] isLoggedIn in
                isLoggedIn ? self.showQuickRecommendation() : self.authenticate()
            }).disposed(by: disposeBag)
        
        input.regularRecommendationButtonTap
            .subscribe(onNext: showRegularRecommendation)
            .disposed(by: disposeBag)
        
        input.rateRecipesButtonTap
            .subscribe(onNext: rateRecipes)
            .disposed(by: disposeBag)
    }
}

// MARK: - Helpers

private extension DashboardViewModel {
    func authenticate() {
        coordinatorDelegate?.goToLoginScreen() { [weak self] in
            self?.showQuickRecommendation()
        }
    }
    
    func showQuickRecommendation() {
        dishService.generateNewQuickRandomDishSuggestion()
            .subscribe(
                onNext: { [weak self] dishId in
                    self?.coordinatorDelegate?.goToDishScreen(dishId: dishId)
                }, onError: { [weak self] error in
                    self?._errorReceived.onNext(error)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showRegularRecommendation() {
        coordinatorDelegate?.goToRecommendationGenerationScreen()
    }
    
    func rateRecipes() {
        coordinatorDelegate?.goToRateRecipesScreen()
    }
}
