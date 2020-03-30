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

class DishViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var recipesTableView: UITableView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var takeawayButton: KawaiiButton!
    @IBOutlet private weak var addRecipeButton: KawaiiButton!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    var viewModel: DishViewModel!
    
    private let recipeCellReuseId = "recipeCell"
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupBindings()
    }
}

// MARK: - Helpers

private extension DishViewController {
    func setupTableView() {
        recipesTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: recipeCellReuseId)
        recipesTableView.tableFooterView = UIView()
    }
    
    func setupBindings() {
        viewModel.dishName
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.dishImageUrl.bind { [weak self] url in
            self?.imageView.imageDownloaded(from: url)
        }.disposed(by: disposeBag)
        
        viewModel.recipesList.bind(
            to: recipesTableView.rx.items(
                cellIdentifier: recipeCellReuseId,
                cellType: RecipeTableViewCell.self)
        ) { row, viewModel, cell in
            cell.configure(with: viewModel)
        }.disposed(by: disposeBag)
        
        takeawayButton.button.rx.tap
            .bind(onNext: viewModel.orderTakeawayCommand)
            .disposed(by: disposeBag)
        
        addRecipeButton.button.rx.tap
            .bind(onNext: viewModel.addRecipeCommand)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .bind(onNext: viewModel.goBackCommand)
            .disposed(by: disposeBag)
    }
}
