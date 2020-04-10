//
//  ServiceDependencies.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class AppServiceDependencies: ServiceDependencies {
    
    private(set) lazy var apiService: APIService = AppAPIService()
    
    private(set) lazy var authenticationService: AuthenticationService = AppAuthenticationService(apiService: apiService)
    
    private(set) lazy var dishService: DishService = FakeDishService()
    
    private(set) lazy var userService: UserService = AppUserService(authenticationService: authenticationService)

}
