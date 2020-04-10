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
        // TODO: Add the other options
    }
    
    func transform(_ input: Input) -> Void {
        input.quickRecommendationButtonTap.subscribe(onNext: quickRecommendation).disposed(by: disposeBag)
    }
}

// MARK: - Helpers

private extension DashboardViewModel {
    func quickRecommendation() {
        guard (try? authenticationService.isAuthenticated.value()) ?? false else {
            authenticate()
            return
        }
        showQuickRecommendation()
    }
    
    func authenticate() {
        coordinatorDelegate?.goToLoginScreen() { [weak self] in
            self?.quickRecommendation()
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
}
