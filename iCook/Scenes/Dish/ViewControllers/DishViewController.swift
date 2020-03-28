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
    
    // MARK: - Properties
    
    var viewModel: DishViewModel!
    
    private let recipeCellReuseId = "recipeCell"
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesTableView.delegate = self
        recipesTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: recipeCellReuseId)
        
        takeawayButton.onTap = { [weak self] in
            self?.onTapTakeawayButton()
        }
        
        addRecipeButton.onTap = { [weak self] in
            self?.onTapAddRecipeButton()
        }
        
        setupBindings()
    }
    
    // MARK: - Actions
    
    @IBAction func onTapBackButton(_ sender: Any) {
        viewModel.goBackCommand()
    }
}

// MARK: - Helpers

private extension DishViewController {
    func onTapTakeawayButton() {
        viewModel.orderTakeawayCommand()
    }
    
    func onTapAddRecipeButton() {
        viewModel.addRecipeCommand()
    }
    
    func setupBindings() {
        viewModel.dishName.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        
        viewModel.dishImageUrl.bind { [weak self] url in
            self?.imageView.downloaded(from: url)
        }.disposed(by: disposeBag)
        
        viewModel.recipesList.bind(
            to: recipesTableView.rx.items(cellIdentifier: recipeCellReuseId, cellType: RecipeTableViewCell.self)
        ){ row, viewModel, cell in
            cell.configure(with: viewModel)
        }.disposed(by: disposeBag)
    }
}

extension DishViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }
}
