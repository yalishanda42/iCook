//
//  DishViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DishViewController: SceneViewController<DishViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var recipesTableView: UITableView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var takeawayButton: KawaiiButton!
    @IBOutlet private weak var addRecipeButton: KawaiiButton!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    private let recipeCellReuseId = "recipeCell"
    
    // MARK: - Setup
    
    override func setupViews() {
        super.setupViews()
        recipesTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: recipeCellReuseId)
        recipesTableView.tableFooterView = UIView()
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        let output = viewModel.transform(DishViewModel.Input(
            takeawayButtonTap: takeawayButton.button.rx.tap.asObservable(),
            addRecipeButtonTap: addRecipeButton.button.rx.tap.asObservable(),
            doneButtonTap: doneButton.rx.tap.asObservable(),
            recipeTap: recipesTableView.rx.itemSelected.map { $0.row }.asObservable()
        ))
        
        output.dishName
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
                
        output.dishImageUrl.drive (onNext: { [weak self] url in
            self?.imageView.imageDownloaded(from: url)
        }).disposed(by: disposeBag)
        
        output.recipesViewModels.drive(recipesTableView.rx.items(
            cellIdentifier: recipeCellReuseId,
            cellType: RecipeTableViewCell.self)
        ) { row, viewModel, cell in
            cell.configure(with: viewModel)
        }.disposed(by: disposeBag)
    }
}
