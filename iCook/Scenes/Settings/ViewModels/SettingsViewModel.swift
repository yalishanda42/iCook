//
//  SettingsViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 10.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SettingsViewModelCoordinatorDelegate: Coordinator {
    func gotoLogIn()
}

class SettingsViewModel: SceneViewModel {
    
    // MARK: - Coordinator
    
    weak var coordinatorDelegate: SettingsViewModelCoordinatorDelegate?
    
    // MARK: - Properties
    
    private let userNames = BehaviorSubject<String>(value: "")
    private let userEmail = BehaviorSubject<String>(value: "")
    
    private var userDetailsAreHidden: Driver<Bool> {
        authenticationService.isAuthenticated.asDriver(onErrorJustReturn: false).map(!)
    }
    
    private var userButtonText: Driver<String> {
        userDetailsAreHidden.map { $0 ? "Влез" : "Излез" }
    }
    
    private let authenticationService: AuthenticationService
    private let userService: UserService
    
    // MARK: - Initialization
    
    init(userService: UserService, authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        self.userService = userService
        super.init()
        
        authenticationService.isAuthenticated.subscribe(onNext: { [weak self] _ in
            self?.load()
        }).disposed(by: disposeBag)
    }
}

// MARK: - IO Transformable

extension SettingsViewModel: IOTransformable {
    struct Input {
        let userButtonTap: Observable<Void>
        let viewDidAppear: Observable<Void>
    }
    
    struct Output {
        let namesText: Driver<String>
        let emailText: Driver<String>
        let userButtonText: Driver<String>
        let namesAreHidden: Driver<Bool>
        let emailIsHidden: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        input.viewDidAppear.subscribe(onNext: load).disposed(by: disposeBag)
        input.userButtonTap
            .withLatestFrom(authenticationService.isAuthenticated)
            .subscribe(onNext: { [unowned self] isLoggedIn in
                isLoggedIn ? self.onTapLogOutButton() : self.onTapLogInButton()
            }).disposed(by: disposeBag)
        
        return Output(
            namesText: userNames.asDriver(onErrorJustReturn: ""),
            emailText: userEmail.asDriver(onErrorJustReturn: ""),
            userButtonText: userButtonText,
            namesAreHidden: userDetailsAreHidden,
            emailIsHidden: userDetailsAreHidden
        )
    }
}

// MARK: - Helpers

private extension SettingsViewModel {
    func onTapLogOutButton() {
        // TODO: Ask user if they are sure about logging out via an alert
        authenticationService.logout().subscribe(onNext: load, onError: { [weak self] error in
            self?.errorSubject.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func onTapLogInButton() {
        coordinatorDelegate?.gotoLogIn()
    }
    
    func load() {
        userService.fetchUserData().subscribe(
            onNext: { [weak self] user in
                guard let self = self else { return }
                
                self.userNames.onNext("\(user.firstName) \(user.familyName)")
                self.userEmail.onNext(user.email)
                
            }, onError: { [weak self] error in
                guard let self = self else { return }
                guard error is AuthenticationError else {
                    self.errorSubject.onNext(error)
                    return
                }
                
                self.userNames.onNext("")
                self.userEmail.onNext("")
                
            }).disposed(by: disposeBag)
    }
}
