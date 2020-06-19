//
//  AuthenticateViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AuthenticateViewModelCoordinatorDelegate: Coordinator {
    func goToRegister()
    func goBack()
}

class AuthenticateViewModel: SceneViewModel {

    // MARK: - Coordinator

    weak var coordinatorDelegate: AuthenticateViewModelCoordinatorDelegate?

    // MARK: - Properties

    let firstNameIsHidden: Bool
    let familyNameIsHidden: Bool
    let screenTitleText: String
    let repeatPasswordFieldIsHidden: Bool
    let registerButtonIsHidden: Bool
    let backButtonIsHidden: Bool

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
            screenTitleText = "Вход"
            repeatPasswordFieldIsHidden = true
            registerButtonIsHidden = false
            backButtonIsHidden = true
        case .register:
            firstNameIsHidden = false
            familyNameIsHidden = false
            screenTitleText = "Регистрация"
            repeatPasswordFieldIsHidden = false
            registerButtonIsHidden = true
            backButtonIsHidden = false
        }
        
        super.init()
    }
}

// MARK: - Authentication Scene Type

extension AuthenticateViewModel {
    enum AuthenticationSubScene {
        case login
        case register
    }
}

// MARK: - IO Bindings

extension AuthenticateViewModel: IOTransformable {
    struct Input {
        // Text
        let firstNameText: Observable<String>
        let familyNameText: Observable<String>
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let passwordRepeatedText: Observable<String>
        // Button taps
        let continueButtonTap: Observable<Void>
        let goResgisterButtonTap: Observable<Void>
        let goBackButtonTap: Observable<Void>
    }
    
    func transform(_ input: Input) -> Void {
        input.goBackButtonTap.subscribe(onNext: goBack).disposed(by: disposeBag)
        input.goResgisterButtonTap.subscribe(onNext: goRegister).disposed(by: disposeBag)
        
        let authenticateSuccess: Observable<Void>
        switch type {
        case .login:
            authenticateSuccess = input.continueButtonTap.withLatestFrom(Observable.combineLatest(
                input.emailText,
                input.passwordText
            )).flatMapLatest(login(email:password:))
        case .register:
            authenticateSuccess = input.continueButtonTap.withLatestFrom(Observable.combineLatest(
                input.firstNameText,
                input.familyNameText,
                input.emailText,
                input.passwordText
            )).flatMapLatest(register(firstName:famiyName:email:password:))
        }
        
        authenticateSuccess.subscribe(onNext: finish).disposed(by: disposeBag)
    }
}

// MARK: - Helpers

private extension AuthenticateViewModel {

    func goRegister() {
        guard type != .register else {
            AppDelegate.logger.error("Incorrect behaviour! Tried to go to Register from Register!")
            return
        }
        
        coordinatorDelegate?.goToRegister()
    }

    func goBack() {
        coordinatorDelegate?.goBack()
    }
    
    func finish() {
        coordinatorDelegate?.finish()
    }

    func login(email: String, password: String) -> Observable<Void> {
        authenticationService
            .login(email: email, password: password)
            .catchErrorPublishAndReturnEmpty(toRelay: _errorRelay)
    }

    func register(firstName: String, famiyName: String, email: String, password: String) -> Observable<Void> {
        authenticationService
            .register(firstName: firstName, famiyName: famiyName, email: email, password: password)
            .catchErrorPublishAndReturnEmpty(toRelay: _errorRelay)
            .flatMapLatest { [weak self] _ in
                self?.login(email: email, password: password) ?? .empty()
            }
    }
}
