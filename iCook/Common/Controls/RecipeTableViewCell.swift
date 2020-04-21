//
//  RecipeTableViewCell.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell, XibLoadable {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var fiveStarView: FiveStarView!
    
    // MARK: - Initialization
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    // MARK: - ViewModel
    
    private var viewModel: RecipeOverviewViewModel?
    
    func configure(with viewModel: RecipeOverviewViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.description
        fiveStarView.configureStars(showingRating: viewModel.rating)
    }
}
