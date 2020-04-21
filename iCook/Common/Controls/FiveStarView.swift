//
//  FiveStarView.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

@IBDesignable
class FiveStarView: UIView, XibLoadable {
    
    // MARK: - Outlets

    /// Star-shaped ImageView's with tag [1-5] counted from leading to trailing end.
    @IBOutlet private var starImageViews: [UIImageView]!
    
    /// The container StackView of the star ImageViews
    @IBOutlet private weak var starsStackView: UIStackView!
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    // MARK: - Stars Configuration
    
    /// Configure the state of the stars (full, half-full, empty) based on a
    /// 'rating' from 0 to 10 inclusively.
    func configureStars(showingRating rating: Int) {
        let fullStars = Float(rating) / 2.0
        
        for star in starImageViews {
            let higherEnd = Float(star.tag)
            let lowerEnd = higherEnd - 1.0
            
            let starState: StarState
            if higherEnd <= fullStars {
                starState = .full
            } else if lowerEnd < fullStars && fullStars < higherEnd {
                starState = .half
            } else {
                starState = .empty
            }
            
            star.image = starState.image
        }
    }
}

// MARK: - Helpers

private extension FiveStarView {
    enum StarState: String {
        case full = "star.fill"
        case half = "star.lefthalf.fill"
        case empty = "star"
        
        var image: UIImage? {
            return UIImage(systemName: self.rawValue)
        }
    }
}
