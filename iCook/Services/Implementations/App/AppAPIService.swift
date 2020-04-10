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

// MARK: - API Service

extension AppAPIService: APIService {
    
    // MARK: - Login
    
    func login(email: String, password: String) -> Observable<BearerToken> {
        
        let endpoint = Endpoint.login(email: email, password: password)
        
        return performRequest(to: endpoint, responseType: APITokenResponse.self).map { $0.token }
    }
    
    // MARK: - Create User
    
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String
    ) -> Observable<Bool> {
        
        let endpoint = Endpoint.createUser(firstName: firstName, famiyName: famiyName, email: email, password: password)
        
        return performRequest(to: endpoint, responseType: APIBaseResponse.self).map { _ in true }
    }
    
    // MARK: - Validate Token
    
    func validateToken(_ token: BearerToken) -> Observable<Bool> {
        return performRequest(
            to: Endpoint.validateToken,
            responseType: APIUserDataResponse.self,
            authenticateWith: token).map { _ in true }
    }
}

// MARK: - Endpoints

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
        
        var requiresAuthentication: Bool {
            switch self {
            case .login, .createUser:
                return false
            case .validateToken, .updateUser:
                return true
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

// MARK: - Parameters

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
    func performRequest<ResponseType: APIResponse>(
        to endpoint: Endpoint,
        responseType: ResponseType.Type,
        authenticateWith token: BearerToken = BearerToken()
    ) -> Observable<ResponseType> {
        return Observable.create { observer -> Disposable in
            let request = AF.request(
                endpoint.url,
                method: endpoint.httpRequestMethod,
                parameters: endpoint.parameters,
                encoding: JSONEncoding.default,
                headers: HTTPHeaders(endpoint.requiresAuthentication ? [HTTPHeader.authorization(bearerToken: token)] : [])
            ).responseJSON { responseResult in
                AppDelegate.logger.trace("\n> Received API response:\n>> Status code \(String(describing: responseResult.response?.statusCode))\n>> Result: \(responseResult.result)")
                
                switch responseResult.result {
                case .success:
                    // Response received!
                    
                    guard let data = responseResult.data else {
                        AppDelegate.logger.error("Response with no data received!")
                        observer.onError(APIConnectionError.connectionFailure(failureMessage: "Response with no data received!"))
                        return
                    }
                    
                    guard let statusCode = responseResult.response?.statusCode else {
                        AppDelegate.logger.error("Response with no status code received!")
                        observer.onError(APIConnectionError.connectionFailure(failureMessage: "Response with no status code received!"))
                        return
                    }
                    
                    guard statusCode == 200 else {
                        // Response received is of type APIBaseResponse because status code is not "200 OK"
                        
                        let serverResponse: APIBaseResponse
                        do {
                            serverResponse = try JSONDecoder().decode(APIBaseResponse.self, from: data)
                        } catch let error {
                            AppDelegate.logger.error("Could not decode base server response! \(error.localizedDescription)")
                            observer.onError(error)
                            return
                        }
                        
                        let message = serverResponse.message
                        
                        switch statusCode {
                        case 400:
                            observer.onError(APIConnectionError.badRequest(serverMessage: message))
                        case 401:
                            observer.onError(APIConnectionError.unauthorized(serverMessage: message))
                        case 404:
                            observer.onError(APIConnectionError.notFound(serverMessage: message))
                        case 500:
                            observer.onError(APIConnectionError.internalServerError(serverMessage: message))
                        default:
                            observer.onError(APIConnectionError.unknownError(serverMessage: message))
                        }
                        return
                    }
                    
                    // Response received is of the needed type because the status code is "200 OK"
                    
                    let serverResponse: ResponseType
                    do {
                        serverResponse = try JSONDecoder().decode(ResponseType.self, from: data)
                    } catch let error {
                        AppDelegate.logger.error("Could not decode response of type \(String(describing: ResponseType.self)) for endpoint \(endpoint)! \(error.localizedDescription)")
                        observer.onError(error)
                        return
                    }
                    
                    observer.onNext(serverResponse)
                    observer.onCompleted()

                case .failure(let error):
                    // No response received.
                    observer.onError(APIConnectionError.connectionFailure(failureMessage: error.localizedDescription))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
