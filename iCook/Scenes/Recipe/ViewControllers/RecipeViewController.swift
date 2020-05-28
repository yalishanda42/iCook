//
//  RecipeViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxCocoa

class RecipeViewController: SceneViewController<RecipeViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var fiveStarView: FiveStarView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var recipeStepsTextView: UITextView!
    @IBOutlet private weak var commentsButtond: KawaiiButton!
    @IBOutlet private weak var productsButton: KawaiiButton!
    
    // MARK: - Properties
    
    private let doneButton = UIBarButtonItem(title: "Публикувай", style: .done, target: nil, action: nil)
    
    // MARK: - Setup
    
    override func setupBindings() {
        super.setupBindings()
        
        let output = viewModel.transform(RecipeViewModel.Input(
            viewDidAppear: rx.viewDidAppear.map { _ in }.asObservable(),
            doneButtonTapped: doneButton.rx.tap.asObservable(),
            stepsText: recipeStepsTextView.rx.text.orEmpty.asObservable(),
            commentButtonTapped: commentsButtond.button.rx.tap.asObservable(),
            productsButtonTapped: productsButton.button.rx.tap.asObservable()
        ))
        
        output.recipeText.drive(recipeStepsTextView.rx.text).disposed(by: disposeBag)
        output.authorInfoText.drive(authorLabel.rx.text).disposed(by: disposeBag)
        output.ratingIsHidden.drive(fiveStarView.rx.isHidden).disposed(by: disposeBag)
        output.commentsButtonIsHidden.drive(commentsButtond.rx.isHidden).disposed(by: disposeBag)
        output.stepsTextIsEditable.drive(onNext: updateTextViewIsEditable).disposed(by: disposeBag)
        output.doneButtonIsHidden.drive(onNext: updateDoneButtonVisibility).disposed(by: disposeBag)
        output.recipeRating.drive(onNext: fiveStarView.configureStars).disposed(by: disposeBag)
    }
}

// MARK: - Helpers

private extension RecipeViewController {
    func updateDoneButtonVisibility(isHidden: Bool) {
        navigationItem.rightBarButtonItem = isHidden ? nil : doneButton
        doneButton.isEnabled = !isHidden
    }
    
    func updateTextViewIsEditable(_ isEditable: Bool) {
        recipeStepsTextView.isEditable = isEditable
    }
}
