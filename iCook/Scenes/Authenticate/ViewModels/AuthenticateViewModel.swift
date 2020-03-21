//
//  AuthenticateViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

protocol AuthenticateViewModelCoordinatorDelegate: AnyObject, Coordinator {
    func goToRegister()
    func goBack()
}

class AuthenticateViewModel {
    
    weak var coordinatorDelegate: AuthenticateViewModelCoordinatorDelegate?
    
    let type: AuthenticationSubScene
    
    private let authenticationService: AuthenticationService

    init(type: AuthenticationSubScene, authenticationService: AuthenticationService) {
        self.type = type
        self.authenticationService = authenticationService
    }

    func continueCommand(
        // TODO: Use RxSwift's two-way binding
        firstName: String,
        famiyName: String,
        email: String,
        password: String,
        repeatedPassword: String
    ) {
        switch type {
        case .login:
            login(email: email, password: password)
        case .register:
            register(
                // TODO: Use RxSwift's two-way binding
                firstName: firstName,
                famiyName: famiyName,
                email: email,
                password: password,
                repeatedPassword: repeatedPassword
            )
        }
    }
    
    func goRegisterCommand() {
        guard type != .register else {
            AppDelegate.logger.error("Incorrect behaviour! Tried to go to Register from Register!")
            return
        }
        coordinatorDelegate?.goToRegister()
    }
    
    func goBackCommand() {
        coordinatorDelegate?.goBack()
    }
}

// MARK: - Helpers

private extension AuthenticateViewModel {
    func login(email: String, password: String) {
        authenticationService.login(email: email, password: password) {
            [weak self] success, message in
            guard success else {
                // TODO: handle error
                return
            }
            self?.coordinatorDelegate?.finish()
        }
    }
    
    func register(firstName: String, famiyName: String, email: String, password: String, repeatedPassword: String) {
        guard password == repeatedPassword else {
            // TODO: handle password mismatch
            return
        }
        authenticationService.register(firstName: firstName, famiyName: famiyName, email: email, password: password) { [weak self] success, message in
            guard success else {
                // TODO handle error
                return
            }
            self?.login(email: email, password: password)
        }
    }
}

// MARK: - Authentication Scene Type

extension AuthenticateViewModel {
    enum AuthenticationSubScene {
        case login
        case register
    }
}
