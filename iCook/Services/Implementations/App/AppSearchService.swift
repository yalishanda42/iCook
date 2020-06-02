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
    
    private let disposeBag = DisposeBag()
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func search(for searchTerm: String) -> Observable<[Dish]> {
        apiService
            .search(searchTerm: searchTerm)
            .catchErrorJustReturn([])
            .map { $0.map { dishData in dishData.asDomainDishModel() } }
    }
}
