//
//  ServiceDependencies.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

protocol ServiceDependencies {
    
    var apiService: APIService { get }
    
    var authenticationService: AuthenticationService { get }
    
    var dishService: DishService { get }
        
    var recipeService: RecipeService { get }
    
    var searchService: SearchService { get }
    
    var userService: UserService { get }
    
}
