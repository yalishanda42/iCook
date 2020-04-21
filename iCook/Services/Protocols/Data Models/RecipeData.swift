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

// MARK: - Computed Properties

extension RecipeData {
    var avgRating: Float {
        guard ratings.count > 0 else {
            return 0
        }
        
        return ratings.map { Float($0.rating) }.reduce(0, +) / Float(ratings.count)
    }
}

// MARK: - Conversions

extension RecipeData {
    func asDomainRecipeModel() -> Recipe {
        let comments = ratings.compactMap { $0.asDomainCommentModel() }
        
        return Recipe(authorNames: userNames, authorEmail: userEmail, avgRating: avgRating, steps: steps, comments: comments)
    }
    
    func asDomainRecipeOverviewInfoModel() -> RecipeOverviewInfo {
        let commentsCount = ratings.compactMap { $0.comment }.count  // counting non-null comments only
        
        return RecipeOverviewInfo(id: id, dishId: dishId, authorNames: userNames, authorEmail: userEmail, dateAdded: dateCreated, commentsCount: commentsCount, rating: avgRating)
    }
}
