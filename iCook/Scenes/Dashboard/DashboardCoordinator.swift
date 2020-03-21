//
//  DashboardCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class DashboardCoordinator: TabCoordinator {
    
    var child: Coordinator?
    
    private let navController: UINavigationController
    private let services: ServiceDependencies
    
    private lazy var viewModel: DashboardViewModel = {
        let result = DashboardViewModel(authenticationService: services.authenticationService)
        result.coordinatorDelegate = self
        return result
    }()
    
    private lazy var presentedViewController: DashboardViewController = {
        let result = DashboardViewController.instantiateFromStoryboard()
        result.viewModel = viewModel
        return result
    }()
    
    init(in navController: UINavigationController, services: ServiceDependencies) {
        self.navController = navController
        self.services = services
    }
    
    func start() {
        navController.setViewControllers([presentedViewController], animated: true)
    }
}

extension DashboardCoordinator: DashboardViewModelCoordinatorDelegate {
    func goToLoginScreen() {
        let loginCoordinator = LoginCoordinator(in: presentedViewController, services: services)
        loginCoordinator.start()
    }
    
    func goToDishScreen() {
        print("baklava")  // TEST
    }
}
