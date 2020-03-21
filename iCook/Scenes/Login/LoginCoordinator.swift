//
//  LoginCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class LoginCoordinator: Coordinator {
    
    private let viewController: UIViewController
    private let services: ServiceDependencies
    
    init(in viewController: UIViewController, services: ServiceDependencies) {
        self.viewController = viewController
        self.services = services
    }
    
    func start() {
        let loginViewController = LoginViewController.instantiateFromStoryboard()
        loginViewController.viewModel = LoginViewModel(authenticationService: services.authenticationService)
        viewController.present(loginViewController, animated: true)
    }
}
