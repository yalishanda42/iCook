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
    
    private var dishName: Driver<String> {
        dish.map { $0.name }.asDriver(onErrorJustReturn: "")
    }
    
    private var dishImageUrl: Driver<String> {
        dish.map { $0.imageUrl }.asDriver(onErrorJustReturn: "")
    }
    
    private var dishRecipeViewModels: Driver<[RecipeOverviewViewModel]> {
        dish.map { dish in
                dish.recipeOverviews
                    .map(RecipeOverviewViewModel.init)
                    .sorted { recipe1, recipe2 in recipe1.rating > recipe2.rating  }
            }.asDriver(onErrorJustReturn: [])
    }
    
    private let dishService: DishService
    
    private let dishId: Int 
    
    private let dish: Observable<Dish>
    
    // MARK: - Initialization
    
    init(dishId: Int, dishService: DishService) {
        self.dishId = dishId
        self.dishService = dishService
        self.dish = self.dishService.fetchDishInfo(for: self.dishId)
    }
    
    // MARK: - Loading
    
    func load() {
        dish.subscribe(
                onNext: { dish in
                    AppDelegate.logger.trace("Fetched dish: \(dish)")
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    AppDelegate.logger.notice("Unable to fetch dish with id \(self.dishId): \(error.localizedDescription)")
                    self._errorReceived.onNext(error)
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}

// MARK: - IO Bindings

extension DishViewModel: IOTransformable {
    struct Input {
        let takeawayButtonTap: Observable<Void>
        let addRecipeButtonTap: Observable<Void>
        let doneButtonTap: Observable<Void>
        let recipeTap: Observable<RecipeOverviewViewModel>
    }
    
    struct Output {
        let dishName: Driver<String>
        let dishImageUrl: Driver<String>
        let recipesViewModels: Driver<[RecipeOverviewViewModel]>
    }
    
    func transform(_ input: Input) -> Output {
        input.takeawayButtonTap.subscribe(onNext: orderTakeaway).disposed(by: disposeBag)
        input.addRecipeButtonTap.subscribe(onNext: addRecipe).disposed(by: disposeBag)
        input.doneButtonTap.subscribe(onNext: goBack).disposed(by: disposeBag)
        input.recipeTap.subscribe(onNext: viewRecipe).disposed(by: disposeBag)
        
        return Output(
            dishName: dishName,
            dishImageUrl: dishImageUrl,
            recipesViewModels: dishRecipeViewModels
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
