//
//  RecipeOverviewInfo.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

struct RecipeOverviewInfo: Codable {
    let id: Int
    let dishId: Int
    let authorNames: String
    let authorEmail: String
    let dateAdded: Int
    let commentsCount: Int
    let rating: Float
}
