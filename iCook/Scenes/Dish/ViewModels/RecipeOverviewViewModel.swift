//
//  RecipeOverviewViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class RecipeOverviewViewModel {
    
    var recipeId: Int {
        model.id
    }
        
    var title: String {
        "by \(model.authorNames)"
    }
    
    var description: String {
        "\(formattedDateString) · \(model.commentsCount) comments"
    }
    
    var rating: Float {
        model.rating
    }
        
    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = "YYYY/MM/dd"
        return result
    }()
    
    private var formattedDateString: String {
        dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(model.dateAdded)))
    }
    
    private let model: RecipeOverviewInfo
    
    init(withModel model: RecipeOverviewInfo) {
        self.model = model
    }
}
