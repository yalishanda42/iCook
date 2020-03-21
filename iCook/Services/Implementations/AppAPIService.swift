//
//  AppAPIService.swift
//  iCook
//
//  Created by Alexander Ignatov on 5.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import Alamofire

class AppAPIService {
    private let uriBase = "https://idagotvim.000webhostapp.com/api"
}

extension AppAPIService: APIService {
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<BearerToken, APIAuthenticationError>) -> Void)
    {
        let endpoint = Endpoint.login
        
        let parameters = [
            "email": email,
            "password": password,
        ]
        
        AF.request(
            "\(uriBase)/\(endpoint.rawValue)",
            method: endpoint.httpRequestMethod,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).responseDecodable(of: APITokenResponse.self) { responseResult in
            print(responseResult)
            switch responseResult.result {
            case .success(let response):
                if let token = response.token {
                    completion(.success(token))
                } else {
                    completion(.failure(.invalidCredentials(serverMessage: response.message)))
                }
            case .failure(let error):
                completion(.failure(.connectionFailure(failureMessage: error.localizedDescription)))
            }
        }
    }
    
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String,
        completion: @escaping (Result<String, APIAuthenticationError>) -> Void
    ) {
        let endpoint = Endpoint.createUser
        
        let parameters = [
            "email": email,
            "password": password,
            "firstname": firstName,
            "lastname": famiyName,
        ]
        
        AF.request(
            "\(uriBase)/\(endpoint.rawValue)",
            method: endpoint.httpRequestMethod,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).responseDecodable(of: APIBaseResponse.self) { responseResult in
            print(responseResult)
            switch responseResult.result {
            case .success(let response):
                switch responseResult.response?.statusCode {
                case 200:
                    completion(.success(response.message))
                default:
                    completion(.failure(.invalidCredentials(serverMessage: response.message)))
                }
            case .failure(let error):
                completion(.failure(.connectionFailure(failureMessage: error.localizedDescription)))
            }
        }
    }
}

extension AppAPIService {
    enum Endpoint: String {
        case createUser = "create_user"
        case login = "login"
        case updateUser = "update_user"
        case validateToken = "validate_token"
        
        var httpRequestMethod: HTTPMethod {
            switch self {
            default:
                return .post
            }
        }
    }
}
