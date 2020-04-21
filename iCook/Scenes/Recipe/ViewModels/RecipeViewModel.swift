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
    
    // MARK: - Properties
    
    private let recipeId: Int
    private let recipeService: RecipeService
    private let recipe: Observable<Recipe>
    
    private var recipeText: Driver<String> {
        recipe.map { $0.steps }.asDriver(onErrorJustReturn: "")
    }
    
    private var recipeRating: Driver<Float> {
        recipe.map { $0.avgRating }.asDriver(onErrorJustReturn: 0)
    }
    
    private var authorInfoText: Driver<String> {
        recipe.map { "\($0.authorNames) <\($0.authorEmail)>"}.asDriver(onErrorJustReturn: "")
    }
    
    private var noCommentsTextIsHidden: Driver<Bool> {
        recipe.map { !$0.comments.isEmpty }.asDriver(onErrorJustReturn: false)
    }
    
    private var commentsAreHidden: Driver<Bool> {
        noCommentsTextIsHidden.map(!)
    }
    
    private var commentViewModels: Driver<[CommentViewModel]> {
        recipe.map { $0.comments.map(CommentViewModel.init) }.asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Initialization

    init(recipeId: Int, recipeService: RecipeService) {
        self.recipeId = recipeId
        self.recipeService = recipeService
        self.recipe = recipeService.fetchRecipeInfo(for: recipeId)
        super.init()
    }
    
    // MARK: - Loading
    
    func load() {
        recipe.subscribe(
                onNext: { recipe in
                    AppDelegate.logger.trace("Fetched recipe: \(recipe)")
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    AppDelegate.logger.notice("Unable to fetch recipe with id \(self.recipeId): \(error.localizedDescription)")
                    self._errorReceived.onNext(error)
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}

extension RecipeViewModel: IOTransformable {
    struct Input {
        let viewDidAppear: Observable<Void>
    }
    
    struct Output {
        let recipeText: Driver<String>
        let recipeRating: Driver<Float>
        let authorInfoText: Driver<String>
        let noCommentsTextIsHidden: Driver<Bool>
        let commentsAreHidden: Driver<Bool>
        let commentViewModels: Driver<[CommentViewModel]>
    }
    
    func transform(_ input: Input) -> Output {
        input.viewDidAppear.subscribe(onNext: load).disposed(by: disposeBag)
        
        return Output(
            recipeText: recipeText,
            recipeRating: recipeRating,
            authorInfoText: authorInfoText,
            noCommentsTextIsHidden: noCommentsTextIsHidden,
            commentsAreHidden: commentsAreHidden,
            commentViewModels: commentViewModels
        )
    }
}
