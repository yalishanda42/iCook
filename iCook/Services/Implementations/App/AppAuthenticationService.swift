//
//  AppAuthenticationService.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import CoreData

class AppAuthenticationService: AuthenticationService {
        
    let isAuthenticated: Observable<Bool>
    
    private let bearerToken = BehaviorRelay<APIService.BearerToken?>(value: nil)
    
    private let apiService: APIService
        
    private let disposeBag = DisposeBag()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(apiService: APIService) {
        self.apiService = apiService
        self.isAuthenticated = bearerToken.map { $0 != nil }.asObservable()
        
        if let savedToken = retrieveToken() {
            bearerToken.accept(savedToken)
        }
        
        bearerToken.subscribe(onNext: persistToken).disposed(by: disposeBag)
    }
    
    func login(email: String, password: String) -> Observable<Void> {
        let result = apiService.login(email: email, password: password)
        result.subscribe(onNext: bearerToken.accept,
                         onError: { [weak self] error in
                            self?.bearerToken.accept(nil)
                        }
            ).disposed(by: disposeBag)
        return result.map { _ in }
    }
    
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String
    ) -> Observable<Void> {
        return apiService.register(firstName: firstName, famiyName: famiyName, email: email, password: password)
            .map { _ in }
    }
    
    func validateToken() -> Observable<UserData> {
        guard let token = bearerToken.value else {
            return Observable.error(AuthenticationError.unauthorizedOperation)
        }
        
        return apiService.validateToken(token)
    }
    
    func logout() -> Observable<Void> {
        bearerToken.accept(nil)
        return Observable.just(())
    }
    
    func quickRecommendation() -> Observable<Int> {
        guard let token = bearerToken.value else {
            return Observable.error(AuthenticationError.unauthorizedOperation)
        }
        
        return apiService.quickRecommendation(token)
    }
    
    func createRecipe(dishId: Int, steps: String) -> Observable<Void> {
        guard let  token = bearerToken.value else {
            return Observable.error(AuthenticationError.unauthorizedOperation)
        }
        
        return apiService.postRecipe(token, dishId: dishId, steps: steps)
    }
}

// MARK: - Database helpers

private extension AppAuthenticationService {
        
    func retrieveToken() -> APIService.BearerToken? {
        let request = Token.fetchRequest() as NSFetchRequest<Token>
        let result: [Token]
        
        do {
            result = try context.fetch(request)
        } catch let error {
            AppDelegate.logger.error("Could not execute fetch request for Token (\(error.localizedDescription)).")
            return nil
        }
        
        guard let currentTokenObject = result.last else {
            return nil
        }
        
        return currentTokenObject.bearer
    }
    
    func persistToken(_ token: APIService.BearerToken?) {
        guard let token = token else {
            deleteToken()
            return
        }
        
        guard token != retrieveToken() else { return }
        
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: Token.self), in: context) else {
            AppDelegate.logger.critical("Could not create entity for entity name \(String(describing: Token.self))!")
            return
        }
        
        let newToken = Token(entity: entity, insertInto: context)
        
        newToken.bearer = token
        
        do {
            try context.save()
        } catch let error {
            AppDelegate.logger.error("Could not save context while saving new token! (\(error.localizedDescription)")
        }
    }
    
    func deleteToken() {
        let fetchRequest = Token.fetchRequest() as NSFetchRequest<Token>
        let result: [Token]
        
        do {
            result = try context.fetch(fetchRequest)
        } catch let error {
            AppDelegate.logger.error("Could not fetch query for deletion of a token! \(error.localizedDescription)")
            return
        }
        
        for token in result {
            context.delete(token)
        }
        
        do {
            try context.save()
        } catch let error {
            AppDelegate.logger.error("Could not save context while deleting token! \(error.localizedDescription)")
        }
    }
}
