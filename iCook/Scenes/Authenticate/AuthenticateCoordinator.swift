//
//  AuthenticateCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class AuthenticateCoordinator: Coordinator {
    
    private let viewController: UIViewController
    private let services: ServiceDependencies
    
    private lazy var loginViewModel: AuthenticateViewModel = {
        let result = AuthenticateViewModel(type: .login, authenticationService: services.authenticationService)
        return result
    }()
    
    private lazy var registerViewModel: AuthenticateViewModel = {
        let result = AuthenticateViewModel(type: .register, authenticationService: services.authenticationService)
        return result
    }()
    
    private lazy var loginViewController: AuthenticateViewController = {
        let result = AuthenticateViewController.instantiateFromStoryboard()
        result.viewModel = loginViewModel
        return result
    }()
    
    private lazy var registerViewController: AuthenticateViewController = {
        let result = AuthenticateViewController.instantiateFromStoryboard()
        result.viewModel = registerViewModel
        return result
    }()
    
    init(in viewController: UIViewController, services: ServiceDependencies) {
        self.viewController = viewController
        self.services = services
    }
    
    func start() {
        let navController = UINavigationController()
        navController.setViewControllers([loginViewController], animated: false)
        viewController.present(navController, animated: true)
    }
}
