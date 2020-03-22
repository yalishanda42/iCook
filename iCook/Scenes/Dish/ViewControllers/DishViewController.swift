//
//  DishViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class DishViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var recipesTableView: UITableView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var takeawayButton: KawaiiButton!
    @IBOutlet private weak var addRecipeButton: KawaiiButton!
    
    // MARK: - Properties
    
    var viewModel: DishViewModel!
    
    private let recipeCellReuseId = "recipeCell"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        recipesTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: recipeCellReuseId)
        
        takeawayButton.onTap = { [weak self] in
            self?.onTapTakeawayButton()
        }
        
        addRecipeButton.onTap = { [weak self] in
            self?.onTapAddRecipeButton()
        }
        
        setupViewModelListeners()
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
    
    func setupViewModelListeners() {
        viewModel.onImageChangedListener = { [weak self] in
            guard let self = self else { return }
            self.imageView.image = self.viewModel.image
        }
        viewModel.onRecipesListChangedListener = { [weak self] in
            self?.recipesTableView.reloadData()
        }
        viewModel.onDishNameChangedListener = { [weak self] in
            guard let self = self else { return }
            self.navigationItem.title = self.viewModel.dishName
        }
    }
}

extension DishViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfRecipes
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellReuseId, for: indexPath) as? RecipeTableViewCell else {
            fatalError("Wrong Recipes table view setup.")
        }
        let cellViewModel = viewModel.recipeViewModel(forIndexPath: indexPath)
        cell.configure(with: cellViewModel)
        return cell
    }
}

extension DishViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }
}
