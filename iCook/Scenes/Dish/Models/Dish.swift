//
//  Dish.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

struct Dish: Codable {
    let name: String
    let imageUrl: String
    let recipeOverviews: [RecipeOverviewInfo]
}
