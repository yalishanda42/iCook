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

protocol BrowseViewModelCoordinatorDelegate: AnyObject {
    func gotoDish(id: Int)
}

class BrowseViewModel: SceneViewModel {
    
    weak var coordinatorDelegate: BrowseViewModelCoordinatorDelegate?
        
    private let searchService: SearchService
    
    init(searchService: SearchService) {
        self.searchService = searchService
    }
}

// MARK: - IO Transformable

extension BrowseViewModel: IOTransformable {
    struct Input {
        let searchTerm: Observable<String>
        let resultItemTap: Observable<Int>
    }
    
    struct Output {
        let results: Driver<[DishOverviewViewModel]>
        let resultsAreHidden: Driver<Bool>
        let noResultsViewsAreHidden: Driver<Bool>
        let noResultsText: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        input.resultItemTap.subscribe(onNext: viewDish).disposed(by: disposeBag)
        
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
            $0.isEmpty ? "Потърси нещо." : "Няма резултати."
        }.asDriver(onErrorJustReturn: "Няма резултати.")
    }
}

// MARK: - Helpers

private extension BrowseViewModel {
    func viewDish(id: Int) {
        coordinatorDelegate?.gotoDish(id: id)
    }
}
