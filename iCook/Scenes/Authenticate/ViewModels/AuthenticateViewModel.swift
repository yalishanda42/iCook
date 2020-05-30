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
        continueButtonTap(input: input)
            .subscribe(onNext: sendAuthenticationRequest(email:password:passwordRepeated:firstName:familyName:))
            .disposed(by: disposeBag)
        
        input.goBackButtonTap.subscribe(onNext: goBack).disposed(by: disposeBag)
        
        input.goResgisterButtonTap.subscribe(onNext: goRegister).disposed(by: disposeBag)
    }
}

// MARK: - Helpers

private extension AuthenticateViewModel {

    private func continueButtonTap(input: Input) -> Observable<(String, String, String, String, String)> {
        return input.continueButtonTap.withLatestFrom(Observable.combineLatest(
            input.emailText,
            input.passwordText,
            input.passwordRepeatedText,
            input.firstNameText,
            input.familyNameText
        ))
    }
    
    private func sendAuthenticationRequest(
        email: String,
        password: String,
        passwordRepeated: String,
        firstName: String,
        familyName: String
    ) {
        switch type {
        case .login:
            login(email: email, password: password)
        case .register:
            register(firstName: firstName, famiyName: familyName, email: email, password: password, repeatedPassword: passwordRepeated)
        }
    }

    private func goRegister() {
        guard type != .register else {
            AppDelegate.logger.error("Incorrect behaviour! Tried to go to Register from Register!")
            return
        }
        
        coordinatorDelegate?.goToRegister()
    }

    private func goBack() {
        coordinatorDelegate?.goBack()
    }

    func login(email: String, password: String) {
        authenticationService.login(email: email, password: password)
            .subscribe(
                onNext: { [weak self] _ in
                    self?.coordinatorDelegate?.finish()
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
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
                self?.login(email: email, password: password)
            },
            onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            },
            onCompleted: nil,
            onDisposed: nil
        ).disposed(by: disposeBag)
    }
}
