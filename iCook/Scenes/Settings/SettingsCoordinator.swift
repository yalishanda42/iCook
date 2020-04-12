//
//  SettingsCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

final class SettingsCoordinator: TabCoordinator {
    
    private var child: Coordinator?
    
    private let navController: UINavigationController
    private let services: ServiceDependencies
    
    private lazy var settingsController: SettingsViewController = {
        let result = SettingsViewController.instantiateFromStoryboard()
        result.viewModel = settingsViewModel
        return result
    }()
    
    private lazy var settingsViewModel: SettingsViewModel = {
        let result =  SettingsViewModel(
            userService: services.userService,
            authenticationService:services.authenticationService
        )
        result.coordinatorDelegate = self
        return result
    }()
    
    init(in navController: UINavigationController, services: ServiceDependencies) {
        self.navController = navController
        self.services = services
    }
    
    func start() {
        navController.setViewControllers([settingsController], animated: true)
    }
}

extension SettingsCoordinator: SettingsViewModelCoordinatorDelegate {
    func gotoLogIn() {
        let authCoordinator = AuthenticateCoordinator(in: settingsController, services: services)
        child = authCoordinator
        authCoordinator.start()
    }
}
