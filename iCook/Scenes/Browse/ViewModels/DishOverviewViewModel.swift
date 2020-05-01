//
//  DishOverviewViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 1.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class DishOverviewViewModel {
    
    var id: Int {
        model.id
    }
    
    var imageUrl: String {
        model.imageUrl
    }
    
    var titleText: String {
        model.name
    }
    
    var subtitleText: String {
        "Dish · \(model.recipeOverviews.count) recipes"
    }
    
    private let model: Dish
    
    init(with model: Dish) {
        self.model = model
    }
}
