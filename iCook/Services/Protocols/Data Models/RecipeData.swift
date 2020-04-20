//
//  RecipeData.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

struct RecipeData: Codable {
    let id: Int
    let dishId: Int
    let userId: Int
    let dateCreated: Int
    let duration: Int
    let steps: String
    let userNames: String
    let userEmail: String
    let ratings: [RatingData]
}

extension RecipeData {
    func asDomainRecipeOverviewInfoModel() -> RecipeOverviewInfo {
        let commentsCount = ratings.compactMap { $0.comment }.count  // counting non-null comments only
        
        let rating: Float
        if ratings.count > 0 {
            rating = ratings.map { Float($0.rating) }.reduce(0, +) / Float(ratings.count)  // avg value
        } else {
            rating = 0
        }
        
        return RecipeOverviewInfo(id: id, dishId: dishId, authorNames: userNames, authorEmail: userEmail, dateAdded: dateCreated, commentsCount: commentsCount, rating: rating)
    }
}
