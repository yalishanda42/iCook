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

class SettingsViewModel: SceneViewModel {
    
    private let userNames = BehaviorSubject<String>(value: "")
    private let userEmail = BehaviorSubject<String>(value: "")
    
    private let authenticationService: AuthenticationService
    private let userService: UserService
    
    init(userService: UserService, authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        self.userService = userService
        super.init()
    }
    
    func load() {
        userService.fetchUserData().subscribe(
            onNext: { [weak self] user in
                guard let self = self else { return }
                self.userNames.onNext("\(user.firstName) \(user.familyName)")
                self.userEmail.onNext(user.email)
            }, onError: { [weak self] error in
                self?._errorReceived.onNext(error)
            }).disposed(by: disposeBag)
    }
}

extension SettingsViewModel: IOTransformable {
    struct Input {
        let logOutButtonTap: Observable<Void>
        let viewDidAppear: Observable<Void>
    }
    
    struct Output {
        let namesText: Driver<String>
        let emailText: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        input.logOutButtonTap.subscribe(onNext: onTapLogOutButton).disposed(by: disposeBag)
        input.viewDidAppear.subscribe(onNext: load).disposed(by: disposeBag)
        
        return Output(
            namesText: userNames.asDriver(onErrorJustReturn: ""),
            emailText: userEmail.asDriver(onErrorJustReturn: "")
        )
    }
}

private extension SettingsViewModel {
    func onTapLogOutButton() {
        authenticationService.logout().subscribe().disposed(by: disposeBag)
    }
}
