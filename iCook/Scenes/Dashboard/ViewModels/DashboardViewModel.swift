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
        let quickRecommendationLoggedIn = input.quickRecommendationButtonTap
            .withLatestFrom(authenticationService.isAuthenticated)
            .filter { $0 == true }
            .map { _ in }
            
        let quickRecommendationLoggedOut = input.quickRecommendationButtonTap
            .withLatestFrom(authenticationService.isAuthenticated)
            .filter { $0 == false }
            .map { _ in }
            .flatMapLatest(authenticate)
        
        Observable.merge(quickRecommendationLoggedIn, quickRecommendationLoggedOut)
            .flatMapLatest { [weak self] _ -> Observable<Int> in
                guard let self = self else { return Observable.empty() }
                return self.dishService
                    .generateNewQuickRandomDishSuggestion()
                    .catchErrorPublishAndReturnEmpty(toRelay: self._errorRelay)
            }.subscribe(onNext: showQuickRecommendation(forDishId:))
            .disposed(by: disposeBag)
        
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
    func authenticate() -> Observable<Void> {
        return Observable.create { [weak self] observer in
            self?.coordinatorDelegate?.goToLoginScreen() {
                observer.onNext(())
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func showQuickRecommendation(forDishId dishId: Int) {
        coordinatorDelegate?.goToDishScreen(dishId: dishId)
    }
    
    func showRegularRecommendation() {
        coordinatorDelegate?.goToRecommendationGenerationScreen()
    }
    
    func rateRecipes() {
        coordinatorDelegate?.goToRateRecipesScreen()
    }
}
