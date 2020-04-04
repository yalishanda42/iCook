//
//  SceneViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 4.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SceneViewModel {
    
    final let disposeBag = DisposeBag()
    
    private let _isLoading: BehaviorSubject<Bool>
    let isLoading: Driver<Bool>
    
    init() {
        self._isLoading = BehaviorSubject(value: false)
        self.isLoading = self._isLoading.asDriver(onErrorJustReturn: false)
    }
}
