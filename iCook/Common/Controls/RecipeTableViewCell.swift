//
//  RecipeTableViewCell.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell, XibLoadable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var starsStackView: UIStackView!
    
    /// Star-shaped ImageView's with tag [1-5] counted from leading to trailing end.
    @IBOutlet var starImageViews: [UIImageView]!
    
    private var viewModel: RecipeOverviewViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: RecipeOverviewViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.description
        configureStars(showingRating: viewModel.rating)
    }
    
    private func configureStars(showingRating rating: Int) {
        let fullStars = Double(rating) / 2.0
        for star in starImageViews {
            let higherEnd = Double(star.tag)
            let lowerEnd = higherEnd - 1.0
            
            if higherEnd <= fullStars {
                star.image = StarState.full.image
            } else if lowerEnd < fullStars && fullStars < higherEnd {
                star.image = StarState.half.image
            } else {
                star.image = StarState.empty.image
            }
        }
    }

}

private extension RecipeTableViewCell {
    enum StarState: String {
        case full = "star.fill"
        case half = "star.lefthalf.fill"
        case empty = "star"
        
        var image: UIImage? {
            return UIImage(systemName: self.rawValue)
        }
    }
}
