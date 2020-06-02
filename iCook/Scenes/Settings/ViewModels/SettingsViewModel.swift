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
        let authenticationStateChanged = authenticationService.isAuthenticated.map { _ in }
        
        let loginButtonTap = input.userButtonTap
            .withLatestFrom(authenticationService.isAuthenticated)
            .filter { $0 == false }
            .map { _ in }
        
        let logoutButtonTap = input.userButtonTap
            .withLatestFrom(authenticationService.isAuthenticated)
            .filter { $0 == true }
            .map { _ in }
            .flatMapLatest(authenticationService.logout)
        
        let userResult = Observable
            .merge(input.viewDidAppear, logoutButtonTap, authenticationStateChanged)
            .flatMapLatest(userResults)
            .share()
        
        userResult.map {"\($0.firstName) \($0.familyName)" }.subscribe(userNames).disposed(by: disposeBag)
        userResult.map { $0.email }.subscribe(userEmail).disposed(by: disposeBag)
        
        loginButtonTap.subscribe(onNext: onTapLogInButton).disposed(by: disposeBag)
        
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
    func onTapLogInButton() {
        coordinatorDelegate?.gotoLogIn()
    }
    
    func userResults() -> Observable<User> {
        userService.fetchUserData().catchError { [unowned self] error in
            guard error is AuthenticationError else {
                self.errorSubject.onNext(error)
                return .empty()
            }
            
            self.userNames.onNext("")
            self.userEmail.onNext("")
            return .empty()
        }
    }
}
