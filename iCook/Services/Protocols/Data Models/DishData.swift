//
//  DishData.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

struct DishData: Codable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String
    let recipes: [RecipeData]
}

extension DishData {
    func asDomainDishModel() -> Dish {
        return Dish(
            id: id,
            name: name,
            imageUrl: imageUrl,
            recipeOverviews: recipes.map{ $0.asDomainRecipeOverviewInfoModel() }
        )
    }
}
