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
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchRecipeInfo(for recipeId: Int) -> Observable<Recipe> {
        return apiService.recipe(id: recipeId).map { $0.asDomainRecipeModel() }
    }
}
