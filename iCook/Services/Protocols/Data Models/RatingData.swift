//
//  RatingData.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

struct RatingData: Codable {
    let id: Int
    let recipeId: Int
    let userId: Int
    let rating: Int
    let comment: String?
}
