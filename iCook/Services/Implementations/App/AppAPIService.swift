//
//  AppAPIService.swift
//  iCook
//
//  Created by Alexander Ignatov on 5.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import Alamofire
import Logging
import RxSwift

class AppAPIService {
    private static let uriBase = "https://idagotvim.000webhostapp.com/api"
}

extension AppAPIService: APIService {
    func login(email: String, password: String) -> Observable<BearerToken> {
        
        let endpoint = Endpoint.login(email: email, password: password)
        
        return performRequest(toEndpoint: endpoint, responseType: APITokenResponse.self) { (observer, response) in
            observer.onNext(response.token!)
            observer.onCompleted()
        }
    }
    
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String
    ) -> Observable<Bool> {
        
        let endpoint = Endpoint.createUser(firstName: firstName, famiyName: famiyName, email: email, password: password)
        
        return performRequest(toEndpoint: endpoint, responseType: APIBaseResponse.self) { (observer, response) in
            observer.onNext(true)
            observer.onCompleted()
        }
    }
}

extension AppAPIService {
    enum Endpoint {
        case createUser(firstName: String, famiyName: String, email: String, password: String)
        case login(email: String, password: String)
        case updateUser(firstName: String, famiyName: String, email: String, password: String?)
        case validateToken
        
        var url: String {
            switch self {
            case .createUser:
                return "\(uriBase)/create_user"
            case .login:
                return "\(uriBase)/login"
            case .updateUser:
                return "\(uriBase)/update_user"
            case .validateToken:
                return "\(uriBase)/validate_token"
            }
        }
        
        var httpRequestMethod: HTTPMethod {
            switch self {
            default:
                return .post
            }
        }
        
        var parameters: [String: String] {
            switch self {
            case .createUser(firstName: let firstname, famiyName: let familyname, email: let email, password: let password):
                return [
                    Parameters.firstname: firstname,
                    Parameters.lastname: familyname,
                    Parameters.email: email,
                    Parameters.password: password,
                ]
            case .login(email: let email, password: let password):
                return [
                    Parameters.email: email,
                    Parameters.password: password
                ]
            default:
                return [:]
            }
        }
    }
}

extension AppAPIService {
    enum Parameters {
        static let email = "email"
        static let password = "password"
        static let firstname = "firstname"
        static let lastname = "lastname"
    }
}

// MARK: - Helpers

private extension AppAPIService {
    func performRequest<ResponseType: APIResponse, ReturnType>(
        toEndpoint endpoint: Endpoint,
        responseType: ResponseType.Type,
        onSuccessfulResult successHandler: ((AnyObserver<ReturnType>, ResponseType) -> Void)?
    ) -> Observable<ReturnType> {
        return Observable.create { observer -> Disposable in
            let request = AF.request(
                endpoint.url,
                method: endpoint.httpRequestMethod,
                parameters: endpoint.parameters,
                encoding: JSONEncoding.default
            ).responseDecodable(of: ResponseType.self) { responseResult in
                AppDelegate.logger.trace("Received API response:\nResult: \(responseResult.result)\nStatus code \(String(describing: responseResult.response?.statusCode))")
                
                switch responseResult.result {
                case .success(let response):
                    switch responseResult.response?.statusCode {
                    case 200:
                        successHandler?(observer, response)
                    case 400:
                        observer.onError(APIAuthenticationError.badRequest(serverMessage: response.message))
                    case 401:
                        observer.onError(APIAuthenticationError.unauthorized(serverMessage: response.message))
                    case 404:
                        observer.onError(APIAuthenticationError.notFound(serverMessage: response.message))
                    case 500:
                        observer.onError(APIAuthenticationError.internalServerError(serverMessage: response.message))
                    default:
                        observer.onError(APIAuthenticationError.unknownError(serverMessage: response.message))
                    }
                case .failure(let error):
                    observer.onError(APIAuthenticationError.connectionFailure(failureMessage: error.localizedDescription))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
