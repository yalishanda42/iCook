//
//  AuthenticateCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class AuthenticateCoordinator: Coordinator {
    
    var onFinish: ((_ authenticationSuccessful: Bool) -> Void)?
    
    private let viewController: UIViewController
    private let services: ServiceDependencies
    
    private let navControllerWrapper = UINavigationController()
    
    private lazy var loginViewModel: AuthenticateViewModel = {
        let result = AuthenticateViewModel(type: .login, authenticationService: services.authenticationService)
        result.coordinatorDelegate = self
        return result
    }()
    
    private lazy var registerViewModel: AuthenticateViewModel = {
        let result = AuthenticateViewModel(type: .register, authenticationService: services.authenticationService)
        result.coordinatorDelegate = self
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
        navControllerWrapper.setViewControllers([loginViewController], animated: false)
        viewController.present(navControllerWrapper, animated: true)
    }
    
    func finish() {
        navControllerWrapper.dismiss(animated: true) { [weak self] in
            self?.onFinish?(true)
        }
    }
}

extension AuthenticateCoordinator: AuthenticateViewModelCoordinatorDelegate {
    func goToRegister() {
        navControllerWrapper.pushViewController(registerViewController, animated: true)
    }
    
    func goBack() {
        navControllerWrapper.popViewController(animated: true)
    }
}
