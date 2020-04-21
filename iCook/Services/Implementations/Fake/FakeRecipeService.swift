//
//  FakeRecipeService.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class FakeRecipeService: RecipeService {
    func fetchRecipeInfo(for recipeId: Int) -> Observable<Recipe> {
        return Observable.just(Recipe(
            authorNames: "Alexander Ignatov",
            authorEmail: "yalishanda@abv.bg",
            avgRating: 6.9,
            steps: "Бобът се накисва във студена вода. Хахаа.",
            comments: [
                Comment(text: "Landcore Classic 3", authorNames: "100qn", authorEmail: "100qn@nmp.com"),
                Comment(text: "Най-голямата рецепта! Хахаа", authorNames: "JJ French", authorEmail: "jj@landcore.bg"),
            ]
        ))
    }
}
