//
//  BrowseViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 1.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BrowseViewModel: SceneViewModel {
        
    private let searchService: SearchService
    
    init(searchService: SearchService) {
        self.searchService = searchService
    }
}

// MARK: - IO Transformable

extension BrowseViewModel: IOTransformable {
    struct Input {
        let searchTerm: Observable<String>
    }
    
    struct Output {
        let results: Driver<[DishOverviewViewModel]>
        let resultsAreHidden: Driver<Bool>
        let noResultsViewsAreHidden: Driver<Bool>
        let noResultsText: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let viewModels = results(for: input)
        let resultsAreHidden = viewModels.map { $0.isEmpty }
        let noResultsViewsAreHidden = resultsAreHidden.map(!)
        let noResultsFetchedText = noResultsText(input: input)
        
        return Output(results: viewModels,
                      resultsAreHidden: resultsAreHidden,
                      noResultsViewsAreHidden: noResultsViewsAreHidden,
                      noResultsText: noResultsFetchedText)
    }
    
    private func results(for input: Input) -> Driver<[DishOverviewViewModel]> {
        input.searchTerm
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap(searchService.search)
            .map{ $0.map(DishOverviewViewModel.init) }
            .asDriver(onErrorJustReturn: [])
    }
    
    private func noResultsText(input: Input) -> Driver<String> {
        input.searchTerm.map {
            $0.isEmpty ? "Search for yummy dishes." : "No results available."
        }.asDriver(onErrorJustReturn: "No results available.")
    }
}
