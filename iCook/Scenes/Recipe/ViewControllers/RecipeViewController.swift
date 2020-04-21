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
    @IBOutlet private weak var noCommentsLabel: UILabel!
    @IBOutlet private weak var commentsTableView: UITableView!
    
    // MARK: - Properties
    
    private let commentCellReuseId = "commentCell"
    
    // MARK: - Setup
    
    override func setupViews() {
        super.setupViews()
        commentsTableView.tableFooterView = UIView()  // remove extra horizontal lines
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        let output = viewModel.transform(RecipeViewModel.Input(viewDidLoad: rx.viewDidLoad.asObservable()))
        
        output.recipeText.drive(recipeStepsTextView.rx.text).disposed(by: disposeBag)
        output.authorInfoText.drive(authorLabel.rx.text).disposed(by: disposeBag)
        output.commentsAreHidden.drive(commentsTableView.rx.isHidden).disposed(by: disposeBag)
        output.noCommentsTextIsHidden.drive(noCommentsLabel.rx.isHidden).disposed(by: disposeBag)
        
        output.recipeRating.drive(onNext: configureStars).disposed(by: disposeBag)
        
        output.commentViewModels.drive(commentsTableView.rx.items(
            cellIdentifier: commentCellReuseId,
            cellType: CommentTableViewCell.self)
        ) { row, viewModel, cell in
            cell.configure(with: viewModel)
        }.disposed(by: disposeBag)
    }
}

// MARK: - Helpers

private extension RecipeViewController {
    func configureStars(with rating: Float) {
        fiveStarView.configureStars(showingRating: rating)
    }
}
