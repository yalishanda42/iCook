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
    
    private static var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

// MARK: - API Service

extension AppAPIService: APIService {
        
    func login(email: String, password: String) -> Observable<BearerToken> {
        
        let endpoint: Endpoint = .login(email: email, password: password)
        
        return performSingleRequest(to: endpoint, responseType: APITokenResponse.self).map { $0.token }
    }
        
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String
    ) -> Observable<Bool> {
        
        let endpoint: Endpoint = .createUser(firstName: firstName, famiyName: famiyName, email: email, password: password)
        
        return performSingleRequest(to: endpoint, responseType: APIBaseResponse.self).map { _ in true }
    }
        
    func validateToken(_ token: BearerToken) -> Observable<UserData> {
        return performSingleRequest(
            to: .validateToken,
            responseType: APIUserDataResponse.self,
            authenticateWith: token
        ).map { $0.data }
    }
        
    func quickRecommendation(_ token: BearerToken) -> Observable<Int> {
        return performSingleRequest(
            to: .quickRecommendation,
            responseType: APIIntDataResponse.self,
            authenticateWith: token
        ).map { $0.data }
    }
        
    func dish(id: Int) -> Observable<DishData> {
        return performSingleRequest(to: .dish(id: id), responseType: APIDishDataResponse.self).map { $0.data }
    }
        
    func recipe(id: Int) -> Observable<RecipeData> {
        return performSingleRequest(to: .getRecipe(id: id), responseType: APIRecipeDataResponse.self).map { $0.data }
    }
    
    func search(searchTerm: String) -> Observable<[DishData]> {
        return performSingleRequest(
            to: .search(searchTerm: searchTerm.addingPercentEncoding(withAllowedCharacters: .letters) ?? ""),
            responseType: APIDishDataArrayResponse.self
        ).map { $0.data }
    }
    
    func postRecipe(_ token: BearerToken, dishId: Int, steps: String) -> Observable<Void> {
        return performSingleRequest(
            to: .postRecipe(dishId: dishId, steps: steps),
            responseType: APIBaseResponse.self,
            authenticateWith: token
        ).map { _ in }
    }
}

// MARK: - Endpoints

extension AppAPIService {
    enum Endpoint {
        case createUser(firstName: String, famiyName: String, email: String, password: String)
        case login(email: String, password: String)
        case updateUser(firstName: String, famiyName: String, email: String, password: String?)
        case validateToken
        case quickRecommendation
        case dish(id: Int)
        case getRecipe(id: Int)
        case postRecipe(dishId: Int, steps: String)
        case search(searchTerm: String)
        
        var url: String {
            let path: String
            switch self {
                case .createUser: path = "create_user"
                case .login: path = "login"
                case .updateUser: path = "update_user"
                case .validateToken: path = "validate_token"
                case .quickRecommendation: path = "quick_recommendation"
                case .dish(id: let id): path = "dish/\(id)"
                case .getRecipe(id: let id): path = "recipe/\(id)"
                case .postRecipe: path = "recipe"
                case .search(searchTerm: let term): path = "search/\(term)"
            }
            
            return "\(uriBase)/\(path)"
        }
        
        var httpRequestMethod: HTTPMethod {
            switch self {
            case .dish, .getRecipe, .search:
                return .get
            default:
                return .post
            }
        }
        
        var requiresAuthentication: Bool {
            switch self {
            case .login, .createUser, .dish, .getRecipe, .search:
                return false
            case .validateToken, .updateUser, .quickRecommendation, .postRecipe:
                return true
            }
        }
        
        var parameters: [String: String]? {
            let params: [Parameter: String]
            switch self {
            case .createUser(firstName: let firstname, famiyName: let familyname, email: let email, password: let password):
                params = [
                    .firstname: firstname,
                    .lastname: familyname,
                    .email: email,
                    .password: password,
                ]
            case .login(email: let email, password: let password):
                params = [
                    .email: email,
                    .password: password
                ]
            case .postRecipe(dishId: let dishId, steps: let steps):
                params = [
                    .dishId: "\(dishId)",
                    .steps: steps
                ]
            default:
                return nil
            }
            
            var result: [String: String] = [:]
            params.keys.map { ($0, $0.rawValue) }.forEach { param, paramStr in
                result[paramStr] = params[param]
            }
            return result
        }
    }
}

// MARK: - Parameters

extension AppAPIService {
    enum Parameter: String {
        case email
        case password
        case firstname
        case lastname
        case dishId = "dish_id"
        case steps
    }
}

// MARK: - Helpers

private extension AppAPIService {
    func performSingleRequest<ResponseType: APIResponse>(
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
                headers: HTTPHeaders(endpoint.requiresAuthentication ? [.authorization(bearerToken: token)] : [])
            ).responseJSON { responseResult in
                
                AppDelegate.logger.trace("\n> Received API response for URL \(endpoint.url):\n>> Status code \(String(describing: responseResult.response?.statusCode))\n>> Result: \(responseResult.result)")
                
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
                            serverResponse = try AppAPIService.jsonDecoder.decode(APIBaseResponse.self, from: data)
                        } catch let error {
                            AppDelegate.logger.error("Could not decode base server response! \(error)")
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
                        serverResponse = try AppAPIService.jsonDecoder.decode(ResponseType.self, from: data)
                    } catch let error {
                        AppDelegate.logger.error("Could not decode response of type \(String(describing: ResponseType.self)) for endpoint \(endpoint)! \(error)")
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
        }.share()
    }
}
