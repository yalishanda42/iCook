//
//  APIService.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

protocol APIService {
    
    typealias BearerToken = String

    func login(email: String, password: String) -> Observable<BearerToken>
    
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String
    ) -> Observable<Bool>
    
}

enum APIAuthenticationError: Error {
    case notFound(serverMessage: String)
    case internalServerError(serverMessage: String)
    case badRequest(serverMessage: String)
    case unauthorized(serverMessage: String)
    case unknownError(serverMessage: String)
    
    case connectionFailure(failureMessage: String)
}
