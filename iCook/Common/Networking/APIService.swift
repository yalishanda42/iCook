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

    func authenticate(
        email: String,
        password: String,
        completion: (Result<BearerToken, Error>) -> Void
    )
}
