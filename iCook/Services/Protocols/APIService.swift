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
    
    func validateToken(_ token: BearerToken) -> Observable<UserData>
    
    func quickRecommendation(_ token: BearerToken) -> Observable<Int>
    
}

enum APIConnectionError: Error {
    // Returned from server
    case notFound(serverMessage: String)
    case internalServerError(serverMessage: String)
    case badRequest(serverMessage: String)
    case unauthorized(serverMessage: String)
    case unknownError(serverMessage: String)
    // Cannot reach server
    case connectionFailure(failureMessage: String)
    
    /// Retrieve the localized description for this error.
    var localizedDescription: String {
        switch self {
        case .notFound(serverMessage: let message),
             .internalServerError(serverMessage: let message),
             .badRequest(serverMessage: let message),
             .unauthorized(serverMessage: let message),
             .unknownError(serverMessage: let message),
             .connectionFailure(failureMessage: let message):
            return message
        }
    }
    
    /// Retrieve a short string describing the error type.
    var title: String {
        switch self {
        case .notFound:
            return "Not Found"
        case .internalServerError:
            return "Server Error"
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Unauthorized"
        case .unknownError:
            return "Error"
        case .connectionFailure:
            return "Connection Error"
        }
    }
}
