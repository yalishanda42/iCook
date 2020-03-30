//
//  DishViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxSwift

protocol DishViewModelCoordinatorDelegate: AnyObject, Coordinator {
    func goToTakeaway()
    func goToAddRecipe()
}

class DishViewModel {
    
    // MARK: - Coordinator
        
    weak var coordinatorDelegate: DishViewModelCoordinatorDelegate?
    
    // MARK: - Bindings
    
    let dishName = BehaviorSubject<String>(value: "")
    
    let dishImageUrl = BehaviorSubject<String>(value: "")
    
    let recipesList = BehaviorSubject<[RecipeOverviewViewModel]>(value: [])
    
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let dishService: DishService
    
    private let dishId: Int 
    
    private var dish: Dish?
    
    // MARK: - Initialization
    
    init(dishId: Int, dishService: DishService) {
        self.dishId = dishId
        self.dishService = dishService
    }
    
    // MARK: - Loading
    
    func load() {
        dishService.fetchDishInfo(for: dishId)
            .subscribe(
                onNext: { [weak self] dish in
                    guard let self = self else { return }
                    AppDelegate.logger.trace("Fetched dish: \(dish)")
                    self.dish = dish
                    self.dishName.onNext(dish.name)
                    self.dishImageUrl.onNext(dish.imageUrl)
                    self.recipesList.onNext(dish.recipeOverviews
                                                .map(RecipeOverviewViewModel.init)
                                                .sorted(by: { $0.rating > $1.rating }))
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    AppDelegate.logger.notice("Unable to fetch dish with id \(self.dishId)")
                    // TODO: Handle error
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}

// MARK: - Commands

extension DishViewModel {
    func orderTakeawayCommand(_: Void) {
        coordinatorDelegate?.goToTakeaway()
    }
    
    func addRecipeCommand(_: Void) {
        coordinatorDelegate?.goToAddRecipe()
    }
    
    func goBackCommand(_: Void) {
        coordinatorDelegate?.finish()
    }
}
