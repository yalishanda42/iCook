//
//  AppRecipeService.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class AppRecipeService: RecipeService {
    
    private let apiService: APIService
    private let authenticationService: AuthenticationService
    
    init(apiService: APIService, authenticationService: AuthenticationService) {
        self.apiService = apiService
        self.authenticationService = authenticationService
    }
    
    func fetchRecipeInfo(for recipeId: Int) -> Observable<Recipe> {
        return apiService.recipe(id: recipeId).map { $0.asDomainRecipeModel() }
    }
    
    func submitNewRecipe(for dishId: Int, withStepsText steps: String) -> Observable<Void> {
        return authenticationService.createRecipe(dishId: dishId, steps: steps)
    }
}
