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
        email: String,
        password: String,
        repeatedPassword: String
    ) {
        switch type {
        case .login:
            authenticationService.login(email: email, password: password) {
                [weak self] success, message in
                print(message ?? "Success!")
                self?.coordinatorDelegate?.finish()
            }
        case .register:
            break // TODO: register + login + finish()
        }
    }
    
    func goRegisterCommand() {
        guard type != .register else {
            print("Incorrect behaviour! Tried to go to Register from Register!")
            return
        }
        coordinatorDelegate?.goToRegister()
    }
    
    func goBackCommand() {
        coordinatorDelegate?.goBack()
    }
}

extension AuthenticateViewModel {
    enum AuthenticationSubScene {
        case login
        case register
    }
}
