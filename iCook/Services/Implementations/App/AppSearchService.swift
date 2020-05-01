//
//  AppSearchService.swift
//  iCook
//
//  Created by Alexander Ignatov on 1.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class AppSearchService: SearchService {
    
    private let searchSubject = PublishSubject<[DishData]>()
    private let disposeBag = DisposeBag()
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func search(for searchTerm: String) -> Observable<[Dish]> {
        apiService.search(searchTerm: searchTerm).subscribe(
            onNext: { [weak self] in
                self?.searchSubject.onNext($0)
            }, onError: { [weak self] _ in
                self?.searchSubject.onNext([])
            }
        ).disposed(by: disposeBag)
        
        return searchSubject.asObservable().map { $0.map { dishData in dishData.asDomainDishModel() } }
    }
}
