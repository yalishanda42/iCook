//
//  AuthenticationService.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthenticationService {
            
    var isAuthenticated: BehaviorSubject<Bool> { get }
    
    func login(email: String, password: String) -> Observable<Void>
    
    func register(firstName: String, famiyName: String, email: String, password: String) -> Observable<Bool>
    
    func validateToken() -> Observable<UserData>
    
    func logout() -> Observable<Void>
}

enum AuthenticationError: Error {
    case unauthorizedOperation
    
    /// Retrieve the localized description for this error.
    var localizedDescription: String {
        switch self {
        case .unauthorizedOperation:
            return "An operation which requires authorization was attempted."
        }
    }
}
