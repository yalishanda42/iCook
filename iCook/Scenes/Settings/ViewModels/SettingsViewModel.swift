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
    
    private let userData: Observable<User>
    private let userNames: Observable<String>
    private let userEmail: Observable<String>
    
    private let authenticationService: AuthenticationService
    private let userService: UserService
    
    init(userService: UserService, authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
        self.userService = userService
        self.userData = userService.fetchUserData()
        self.userNames = userData.map { "\($0.firstName) \($0.familyName)"}
        self.userEmail = userData.map { $0.email }
        super.init()
    }
    
    func load() {
        userService.fetchUserData().subscribe(onError: { [weak self] error in
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
