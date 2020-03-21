//
//  APIService.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

protocol APIService {
    
    typealias BearerToken = String

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<BearerToken, APIAuthenticationError>) -> Void
    )
    
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String,
        completion: @escaping (Result<String, APIAuthenticationError>) -> Void
    )
    
}

enum APIAuthenticationError: Error {
    case invalidCredentials(serverMessage: String)
    case connectionFailure(failureMessage: String)
}
