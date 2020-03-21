//
//  AuthenticationService.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

protocol AuthenticationService {
    
    typealias CompletionCallback = (_ success: Bool, _ message: String?) -> Void
    
    var isAuthenticated: Bool { get }
    
    func login(email: String, password: String, completion: @escaping CompletionCallback)
    
    func register(firstName: String, famiyName: String, email: String, password: String, completion: @escaping CompletionCallback)
}
