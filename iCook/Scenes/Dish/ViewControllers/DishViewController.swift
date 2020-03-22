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
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    // MARK: - Properties
    
    var viewModel: DishViewModel!
    
    private let recipeCellReuseId = "recipeCell"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        recipesTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: recipeCellReuseId)
    }
    
    // MARK: - Actions
    
    @IBAction func onTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DishViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return viewModel.numberOfCells
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: recipeCellReuseId, for: indexPath) as? RecipeTableViewCell else {
            fatalError("Wrong Recipes table view setup.")
        }
        return cell
    }
}

extension DishViewController: UITableViewDelegate {
}
