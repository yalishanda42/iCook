//
//  FakeServiceDependencies.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class FakeServiceDependencies: ServiceDependencies {
    
    private(set) lazy var apiService: APIService = AppAPIService()
    
    private(set) lazy var authenticationService: AuthenticationService = FakeAuthenticationService()
    
    private(set) lazy var dishService: DishService = FakeDishService()
    
    private(set) lazy var recipeService: RecipeService = FakeRecipeService()
    
    private(set) lazy var userService: UserService = AppUserService(authenticationService: authenticationService)
    
}
