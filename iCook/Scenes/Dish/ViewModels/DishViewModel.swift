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
    
    typealias OnChangeListener = () -> Void
    
    weak var coordinatorDelegate: DishViewModelCoordinatorDelegate?
    
    private let disposeBag = DisposeBag()
    
    private let dishService: DishService
    
    private let dishId: Int 
    
    private var dish: Dish? {
        didSet {
            dishName = dish?.name
            recipesList = dish?.recipeOverviews
                               .map(RecipeOverviewViewModel.init)
                               .sorted { $0.rating > $1.rating } ?? []
            fetchImageFromUrl(dish?.imageUrl ?? "") { [weak self] image in
                self?.image = image
            }
        }
    }
    
    var onDishNameChangedListener: OnChangeListener?
    private(set) var dishName: String? {
        didSet {
            onDishNameChangedListener?()
        }
    }
    
    var onImageChangedListener: OnChangeListener?
    // TODO: Add UIKit viewmodel extension?
    private(set) var image: UIImage? {
        didSet {
            onImageChangedListener?()
        }
    }
    
    var onRecipesListChangedListener: OnChangeListener?
    private var recipesList: [RecipeOverviewViewModel] = [] {
        didSet {
            onRecipesListChangedListener?()
        }
    }
    
    var numberOfRecipes: Int {
        return recipesList.count
    }
    
    init(dishId: Int, dishService: DishService) {
        self.dishId = dishId
        self.dishService = dishService
    }
    
    func load() {
        dishService.fetchDishInfo(for: dishId)
            .subscribe(
                onNext: { [weak self] dish in
                    AppDelegate.logger.debug("Fetched dish: \(dish)")
                    self?.dish = dish
                }, onError: { error in
                    // TODO: Handle error
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func recipeViewModel(forIndexPath indexPath: IndexPath) -> RecipeOverviewViewModel {
        return recipesList[indexPath.row]
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
    func fetchImageFromUrl(_ url: String?, completion: @escaping (UIImage?) -> Void) {
        guard url == url else {
            completion(nil)
            return
        }
        // TODO
    }
}
