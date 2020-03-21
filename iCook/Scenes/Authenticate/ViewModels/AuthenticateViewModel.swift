//
//  AuthenticateViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class AuthenticateViewModel {
    
    let type: AuthenticationSubScene
    
    private let authenticationService: AuthenticationService

    init(type: AuthenticationSubScene, authenticationService: AuthenticationService) {
        self.type = type
        self.authenticationService = authenticationService
    }

    func loginCommand(email: String, password: String) {
       authenticationService.login(email: email, password: password) { success, message in
           print(message ?? "Success!")
       }
    }
}

extension AuthenticateViewModel {
    enum AuthenticationSubScene {
        case login
        case register
    }
}
