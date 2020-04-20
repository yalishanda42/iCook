//
//  AppDishService.swift
//  iCook
//
//  Created by Alexander Ignatov on 13.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class AppDishService: DishService {
    
    private let apiService: APIService
    private let authenticationService: AuthenticationService
    
    init(apiService: APIService, authenticationService: AuthenticationService) {
        self.apiService = apiService
        self.authenticationService = authenticationService
    }
    
    func generateNewQuickRandomDishSuggestion() -> Observable<Int> {
        return authenticationService.quickRecommendation()
    }
    
    func fetchDishInfo(for dishId: Int) -> Observable<Dish> {
        return apiService.dish(id: dishId).map { $0.asDomainDishModel() }
    }
}
