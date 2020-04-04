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
    
    let _isLoading = BehaviorSubject<Bool>(value: false)
    let isLoading: Driver<Bool>
    
    let _errorReceived = PublishSubject<Error>()
    let errorReceived: Driver<(title: String, message: String)>
    
    init() {
        isLoading = _isLoading.asDriver(onErrorJustReturn: false)
        
        errorReceived = _errorReceived.map { error in
            guard let apiError = error as? APIAuthenticationError else {
                return (title: "Error", message: "😟")
            }
            
            return (title: apiError.title, message: apiError.localizedDescription)
            
        }.asDriver(onErrorJustReturn: ("Error", "😟"))
    }
}
