//
//  Recipe.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

struct Recipe {
    let authorNames: String
    let authorEmail: String
    let avgRating: Float
    let steps: String
    let comments: [Comment]
}
