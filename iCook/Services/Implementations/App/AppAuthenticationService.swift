//
//  AppAuthenticationService.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxSwift
import CoreData

class AppAuthenticationService: AuthenticationService {
        
    let isAuthenticated: Observable<Bool>
    
    private let isAuthenticatedSubject = BehaviorSubject(value: false)
    private let bearerToken = BehaviorSubject<APIService.BearerToken?>(value: nil)
    
    private let apiService: APIService
        
    private let disposeBag = DisposeBag()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(apiService: APIService) {
        self.apiService = apiService
        self.isAuthenticated = isAuthenticatedSubject.asObservable()
        
        bearerToken.map { $0 != nil }.subscribe(isAuthenticatedSubject).disposed(by: disposeBag)
        
        if let savedToken = retrieveToken() {
            bearerToken.onNext(savedToken)
        }
        
        bearerToken.subscribe(onNext: persistToken).disposed(by: disposeBag)
    }
    
    func login(email: String, password: String) -> Observable<Void> {
        let result = apiService.login(email: email, password: password)
        result.subscribe(onNext: { [weak self] token in
                    self?.bearerToken.onNext(token)
                }, onError: { [weak self] error in
                    self?.bearerToken.onNext(nil)
                }, onCompleted: nil, onDisposed: nil
            ).disposed(by: disposeBag)
        return result.map { _ in () }
    }
    
    func register(
        firstName: String,
        famiyName: String,
        email: String,
        password: String
    ) -> Observable<Bool> {
        return apiService.register(firstName: firstName, famiyName: famiyName, email: email, password: password)
    }
    
    func validateToken() -> Observable<UserData> {
        guard let token = try? bearerToken.value() else {
            return Observable.error(AuthenticationError.unauthorizedOperation)
        }
        
        return apiService.validateToken(token)
    }
    
    func logout() -> Observable<Void> {
        bearerToken.onNext(nil)
        return Observable.just(())
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
