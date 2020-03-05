//
//  APIService.swift
//  iCook
//
//  Created by Alexander Ignatov on 5.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    typealias BearerToken = String
    
    private let uriBase = "https://idagotvim.000webhostapp.com/api"
    
    func authenticate(
        email: String,
        password: String,
        completion: (Result<BearerToken, Error>) -> Void)
    {
        let parameters = [
            "email": email,
            "password": password
        ]
        AF.request(
            "\(uriBase)/login",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).responseDecodable(of: APIResponse.self) { response in
            print(response)
        }
    }
}
