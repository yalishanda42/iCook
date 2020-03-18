//
//  LoginViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func loginCommand(email: String, password: String) {
        apiService.authenticate(email: email, password: password) { result in
            print(result)
        }
    }
}
