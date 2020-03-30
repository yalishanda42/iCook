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
    
    func login(email: String, password: String)
    
    func register(firstName: String, famiyName: String, email: String, password: String) -> Observable<Bool>
    
}
