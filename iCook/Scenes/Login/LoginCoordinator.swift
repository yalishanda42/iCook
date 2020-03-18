//
//  LoginCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class LoginCoordinator: Coordinator {
    
    let rootViewController: UINavigationController
    let apiService: APIService
    
    init(_ rootViewController: UINavigationController, apiService: APIService) {
        self.rootViewController = rootViewController
        self.apiService = apiService
    }
    
    func start() {
        let loginViewController = LoginViewController.instantiateFromStoryboard()
        loginViewController.viewModel = LoginViewModel(apiService: apiService)
        rootViewController.setViewControllers([loginViewController], animated: true)
    }
}
