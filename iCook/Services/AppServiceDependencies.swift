//
//  ServiceDependencies.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class AppServiceDependencies: ServiceDependencies {
    
    lazy var apiService: APIService = AppAPIService()
    
    lazy var authenticationService: AuthenticationService = AppAuthenticationService(apiService: apiService)

}
