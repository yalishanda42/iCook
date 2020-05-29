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
    
    let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    let isLoading: Driver<Bool>
    
    let errorSubject = PublishSubject<Error>()
    let errorReceived: Driver<(title: String, message: String)>
    
    init() {
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        
        errorReceived = errorSubject.map { error in
            guard let apiError = error as? APIConnectionError else {
                return (title: "Опа", message: "😟 Нещо се обърка, пробвай пак по-късно.")
            }
            
            return (title: apiError.title, message: apiError.localizedDescription)
            
        }.asDriver(onErrorJustReturn: ("Опа", "😟 Нещо се обърка, пробвай пак по-късно."))
    }
}
