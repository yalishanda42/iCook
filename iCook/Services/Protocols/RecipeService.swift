//
//  RecipeService.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

protocol RecipeService {
    
    func fetchRecipeInfo(for recipeId: Int) -> Observable<Recipe>
    
    func submitNewRecipe(for dishId: Int, withStepsText: String) -> Observable<Void>
    
}
