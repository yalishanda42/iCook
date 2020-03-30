//
//  AuthenticateViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthenticateViewModelCoordinatorDelegate: AnyObject, Coordinator {
    func goToRegister()
    func goBack()
}

class AuthenticateViewModel {
    
    // MARK: - Coordinator
    
    weak var coordinatorDelegate: AuthenticateViewModelCoordinatorDelegate?
    
    // MARK: - Bindings
    
    let firstName = BehaviorSubject<String>(value: "")
    let familyName = BehaviorSubject<String>(value: "")
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    let passwordRepeated = BehaviorSubject<String>(value: "")
    
    let firstNameIsHidden: Bool
    let familyNameIsHidden: Bool
    let screenTitleText: String
    let repeatPasswordFieldIsHidden: Bool
    let registerButtonIsHidden: Bool
    let backButtonIsHidden: Bool
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    private let authenticationService: AuthenticationService
    
    private let type: AuthenticationSubScene
    
    // MARK: - Initialization

    init(type: AuthenticationSubScene, authenticationService: AuthenticationService) {
        self.type = type
        self.authenticationService = authenticationService
        
        switch self.type{
        case .login:
            firstNameIsHidden = true
            familyNameIsHidden = true
            screenTitleText = "Login"
            repeatPasswordFieldIsHidden = true
            registerButtonIsHidden = false
            backButtonIsHidden = true
        case .register:
            firstNameIsHidden = false
            familyNameIsHidden = false
            screenTitleText = "Register"
            repeatPasswordFieldIsHidden = false
            registerButtonIsHidden = true
            backButtonIsHidden = false
        }
        
        self.authenticationService.isAuthenticated
            .subscribe(
                onNext: { [weak self] authenticated in
                    if authenticated {
                        self?.coordinatorDelegate?.finish()
                    } else {
                        // TODO: Handle failure
                    }
                }, onError: { error in
                    // TODO: Handle error
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}

// MARK: - Commands

extension AuthenticateViewModel {
    func continueCommand(_: Void) {
        Observable.combineLatest(email, password, passwordRepeated, firstName, familyName).subscribe(
            onNext: { [unowned self] email, password, passwordRepeated, firstName, familyName in
                guard password == passwordRepeated else {
                    // TODO: Handle password mismatch
                    return
                }
                
                switch self.type {
                case .login:
                    self.login(email: email, password: password)
                case .register:
                    self.register(firstName: firstName, famiyName: familyName, email: email, password: password, repeatedPassword: passwordRepeated)
                }
        }).disposed(by: disposeBag)
    }
    
    func goRegisterCommand(_: Void) {
        guard type != .register else {
            AppDelegate.logger.error("Incorrect behaviour! Tried to go to Register from Register!")
            return
        }
        coordinatorDelegate?.goToRegister()
    }
    
    func goBackCommand(_: Void) {
        coordinatorDelegate?.goBack()
    }
}

// MARK: - Helpers

private extension AuthenticateViewModel {
    func login(email: String, password: String) {
        authenticationService.login(email: email, password: password)
    }
    
    func register(firstName: String, famiyName: String, email: String, password: String, repeatedPassword: String) {
        guard password == repeatedPassword else {
            // TODO: handle password mismatch
            return
        }
        
        authenticationService.register(
            firstName: firstName,
            famiyName: famiyName,
            email: email,
            password: password
        ).subscribe(
            onNext: { [weak self] success in
                if success {
                    self?.login(email: email, password: password)
                } else {
                    // TODO: Handle failure
                }
            },
            onError: { error in
                // TODO: Handle error
            },
            onCompleted: nil,
            onDisposed: nil
        ).disposed(by: disposeBag)
    }
}

// MARK: - Authentication Scene Type

extension AuthenticateViewModel {
    enum AuthenticationSubScene {
        case login
        case register
    }
}
