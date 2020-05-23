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
    
    enum Mode {
        case view(recipeId: Int)
        case create
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
        recipe.compactMap { $0 }.map { "\($0.authorNames) <\($0.authorEmail)>"}.asDriver(onErrorJustReturn: "")
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
    
    // MARK: - Loading
    
    func load() {
        recipe.subscribe(
                onNext: { recipe in
                    AppDelegate.logger.trace("New recipe: \(String(describing: recipe))")
                }, onError: { [weak self] error in
                    guard let self = self else { return }
                    AppDelegate.logger.notice("Unable to fetch recipe: \(error.localizedDescription)")
                    self._errorReceived.onNext(error)
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
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
    }
    
    func transform(_ input: Input) -> Output {
        input.viewDidAppear.subscribe(onNext: load).disposed(by: disposeBag)
        
        return Output(
            recipeText: recipeText,
            recipeRating: recipeRating,
            authorInfoText: authorInfoText,
            noCommentsTextIsHidden: noCommentsTextIsHidden,
            commentsAreHidden: commentsAreHidden,
            commentViewModels: commentViewModels,
            commentLabelIsHidden: isInCreateRecipeMode,
            doneButtonIsHidden: isInCreateRecipeMode.map(!),
            stepsTextIsEditable: isInCreateRecipeMode
        )
    }
}
