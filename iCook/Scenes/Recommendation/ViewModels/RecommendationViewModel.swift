//
//  RecommendationViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 25.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

protocol RecommendationViewModelCoordinatorDelegate: Coordinator {
    func generateDishRecommendation()
}

class RecommendationViewModel: SceneViewModel {
    
    weak var coordinatorDelegate: RecommendationViewModelCoordinatorDelegate?
    
}

// MARK: - IO Transformable

extension RecommendationViewModel: IOTransformable {
    struct Input {
        let generateButtonTap: Observable<Void>
    }
    
    func transform(_ input: Input) -> Void {
        input.generateButtonTap.subscribe(onNext:generateRecommendation).disposed(by: disposeBag)
    }
}

// MARK: - Helpers

private extension RecommendationViewModel {
    func generateRecommendation() {
        coordinatorDelegate?.generateDishRecommendation()
    }
}
