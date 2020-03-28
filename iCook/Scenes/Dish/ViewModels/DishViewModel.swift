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
    
    // MARK: - Output
    
    let dishName = BehaviorSubject<String>(value: "")
    
    let dishImageUrl = BehaviorSubject<String>(value: "")
    
    let recipesList = BehaviorSubject<[RecipeOverviewViewModel]>(value: [])
    
    
    // MARK: - Private
    
    private let disposeBag = DisposeBag()
    
    private let dishService: DishService
    
    private let dishId: Int 
    
    private var dish: Dish?
    
    init(dishId: Int, dishService: DishService) {
        self.dishId = dishId
        self.dishService = dishService
    }
    
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
    
    func orderTakeawayCommand() {
        coordinatorDelegate?.goToTakeaway()
    }
    
    func addRecipeCommand() {
        coordinatorDelegate?.goToAddRecipe()
    }
    
    func goBackCommand() {
        coordinatorDelegate?.finish()
    }
}

extension DishViewModel {
    // TODO: Add extension to all viewmodels (generic ViewModel protocol?) or a service? or both, in layers?
    func fetchImageFromUrl(_ url: String?, completion: @escaping (UIImage) -> Void) {
        guard url == url else {
            completion(UIImage()) // TODO: Should be a fallback image
            return
        }
        // TODO: Implement image fetcher
    }
}
