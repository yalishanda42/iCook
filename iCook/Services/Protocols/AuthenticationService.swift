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
    
    // Strictly related to authentication
            
    var isAuthenticated: Observable<Bool> { get }
    
    func login(email: String, password: String) -> Observable<Void>
    
    func register(firstName: String, famiyName: String, email: String, password: String) -> Observable<Bool>
    
    func validateToken() -> Observable<UserData>
    
    func logout() -> Observable<Void>
    
    // Just requiring authentication
    
    func quickRecommendation() -> Observable<Int>
    
    func createRecipe(dishId: Int, steps: String) -> Observable<Void>
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
