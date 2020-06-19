//
//  RecipeViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RecipeViewModel: SceneViewModel {
    
    // MARK: - Coordinator
    
    weak var coordinatorDelegate: Coordinator?
    
    // MARK: - Function Mode
    
    enum Mode {
        case view(recipeId: Int)
        case create(dishId: Int)
    }
    
    // MARK: - Properties
    
    private let mode: Mode
    private let recipe: Observable<Recipe?>
    private let recipeService: RecipeService
    
    private var recipeText: Driver<String> {
        recipe.compactMap { $0?.steps }.asDriver(onErrorJustReturn: "")
    }
    
    private var recipeRating: Driver<Float> {
        recipe.compactMap { $0?.avgRating }.asDriver(onErrorJustReturn: 0)
    }
    
    private var authorInfoText: Driver<String> {
        recipe.map {
            if let recipe = $0 {
                return "\(recipe.authorNames) <\(recipe.authorEmail)>"
            } else {
                return ""
            }
        }.asDriver(onErrorJustReturn: "")
    }
    
    private var noCommentsTextIsHidden: Driver<Bool> {
        recipe.compactMap { !($0?.comments.isEmpty ?? false) }.asDriver(onErrorJustReturn: false)
    }
    
    private var commentsAreHidden: Driver<Bool> {
        recipe.compactMap { $0?.comments.isEmpty }.asDriver(onErrorJustReturn: false)
    }
    
    private var commentViewModels: Driver<[CommentViewModel]> {
        recipe.compactMap { $0?.comments.map(CommentViewModel.init) }.asDriver(onErrorJustReturn: [])
    }
    
    private var isInCreateRecipeMode: Driver<Bool> {
        recipe.map { $0 == nil }.asDriver(onErrorJustReturn: true)
    }
    
    // MARK: - Initialization

    init(withMode mode: Mode, recipeService: RecipeService) {
        self.mode = mode
        self.recipeService = recipeService
        
        switch mode {
        case .view(recipeId: let id):
            self.recipe = recipeService.fetchRecipeInfo(for: id).map { $0 }
        default:
            self.recipe = Observable.just(nil)
        }
        
        super.init()
    }
}

extension RecipeViewModel: IOTransformable {
    struct Input {
        let viewDidAppear: Observable<Void>
        let doneButtonTapped: Observable<Void>
        let stepsText: Observable<String>
    }
    
    struct Output {
        let recipeText: Driver<String>
        let recipeRating: Driver<Float>
        let authorInfoText: Driver<String>
        let noCommentsTextIsHidden: Driver<Bool>
        let commentsAreHidden: Driver<Bool>
        let commentViewModels: Driver<[CommentViewModel]>
        let commentLabelIsHidden: Driver<Bool>
        let doneButtonIsHidden: Driver<Bool>
        let stepsTextIsEditable: Driver<Bool>
        let ratingIsHidden: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        input.viewDidAppear
            .subscribe(onNext: load)
            .disposed(by: disposeBag)

        input.doneButtonTapped
            .withLatestFrom(input.stepsText)
            .subscribe(onNext: submitNewRecipe)
            .disposed(by: disposeBag)
        
        return Output(
            recipeText: recipeText,
            recipeRating: recipeRating,
            authorInfoText: authorInfoText,
            noCommentsTextIsHidden: noCommentsTextIsHidden,
            commentsAreHidden: commentsAreHidden,
            commentViewModels: commentViewModels,
            commentLabelIsHidden: isInCreateRecipeMode,
            doneButtonIsHidden: isInCreateRecipeMode.map(!),
            stepsTextIsEditable: isInCreateRecipeMode,
            ratingIsHidden: isInCreateRecipeMode
        )
    }
}

// MARK: - Helpers

private extension RecipeViewModel {
    func load() {
        switch mode {
        case .view(recipeId: let id):
            recipe.subscribe(
                onNext: { recipe in
                    AppDelegate.logger.trace("New recipe: \(String(describing: recipe))")
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    AppDelegate.logger.notice("Unable to fetch recipe with id \(id): \(error.localizedDescription)")
                    self._errorRelay.accept(error)
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        default:
            break
        }
    }
    
    func submitNewRecipe(_ stepsText: String) {
        switch mode {
        case .create(dishId: let id):
            recipeService
                .submitNewRecipe(for: id, withStepsText: stepsText)
                .subscribe(onNext: goBack, onError: { [weak self] error in
                    guard let self = self else { return }
                    AppDelegate.logger.notice("Unable submit new recipe for dish with id \(id): \(error.localizedDescription)")
                    self._errorRelay.accept(error)
                }).disposed(by: disposeBag)
        default:
            AppDelegate.logger.error("Should not be able to submit new message while not in 'create' mode!")
        }
    }
    
    func goBack() {
        coordinatorDelegate?.finish()
    }
}
