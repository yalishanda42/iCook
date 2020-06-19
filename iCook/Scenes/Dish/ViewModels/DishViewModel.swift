//
//  DishViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DishViewModelCoordinatorDelegate: Coordinator {
    func goToTakeaway()
    func goToAddRecipe()
    func goToRecipe(recipeId: Int)
}

class DishViewModel: SceneViewModel {
    
    // MARK: - Coordinator
        
    weak var coordinatorDelegate: DishViewModelCoordinatorDelegate?
    
    // MARK: - Properties
    
    private let dishService: DishService
    private let authenticationService: AuthenticationService
    private let dishId: Int
    
    // MARK: - Initialization
    
    init(dishId: Int, dishService: DishService, authenticationService: AuthenticationService) {
        self.dishId = dishId
        self.dishService = dishService
        self.authenticationService = authenticationService
    }
}

// MARK: - IO Bindings

extension DishViewModel: IOTransformable {
    struct Input {
        let viewDidAppear: Observable<Void>
        let takeawayButtonTap: Observable<Void>
        let addRecipeButtonTap: Observable<Void>
        let doneButtonTap: Observable<Void>
        let recipeTap: Observable<RecipeOverviewViewModel>
    }
    
    struct Output {
        let dishName: Driver<String>
        let dishImageUrl: Driver<String>
        let recipesViewModels: Driver<[RecipeOverviewViewModel]>
        let addRecipeButtonIsHidden: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let dish = input.viewDidAppear
            .flatMapLatest { [weak self] _ -> Observable<Dish> in
                guard let self = self else { return .empty() }
                return self.dishService
                    .fetchDishInfo(for: self.dishId)
                    .catchErrorPublishAndReturnEmpty(toRelay: self._errorRelay)
            }.asDriverIgnoringError()
        
        let dishName = dish.map { $0.name }
        let dishImageUrl = dish.map { $0.imageUrl }
        let dishRecipeViewModels = dish.map { dish in
            dish.recipeOverviews
                .map(RecipeOverviewViewModel.init)
                .sorted { $0.rating > $1.rating  }
        }
        
        let isNotAuthenticated = authenticationService.isAuthenticated.map(!).asDriverIgnoringError()
        
        input.takeawayButtonTap.subscribe(onNext: orderTakeaway).disposed(by: disposeBag)
        input.addRecipeButtonTap.subscribe(onNext: addRecipe).disposed(by: disposeBag)
        input.doneButtonTap.subscribe(onNext: goBack).disposed(by: disposeBag)
        input.recipeTap.subscribe(onNext: viewRecipe).disposed(by: disposeBag)
        
        return Output(
            dishName: dishName,
            dishImageUrl: dishImageUrl,
            recipesViewModels: dishRecipeViewModels,
            addRecipeButtonIsHidden: isNotAuthenticated
        )
    }
}

// MARK: - Helpers

extension DishViewModel {
    private func orderTakeaway() {
        coordinatorDelegate?.goToTakeaway()
    }
    
    private func addRecipe() {
        coordinatorDelegate?.goToAddRecipe()
    }
    
    private func viewRecipe(of viewModel: RecipeOverviewViewModel) {
        coordinatorDelegate?.goToRecipe(recipeId: viewModel.recipeId)
    }
    
    private func goBack() {
        coordinatorDelegate?.finish()
    }
}
