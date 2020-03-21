//
//  DashboardViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

protocol DashboardViewModelCoordinatorDelegate: AnyObject {
    func goToLoginScreen()
    func goToDishScreen()
}

class DashboardViewModel {
    
    weak var coordinatorDelegate: DashboardViewModelCoordinatorDelegate?
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func quickRecommendationCommand() {
        guard authenticationService.isAuthenticated else {
            coordinatorDelegate?.goToLoginScreen()
            return
        }
        
        coordinatorDelegate?.goToDishScreen()  // TEST
    }
}
