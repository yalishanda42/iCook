//
//  SceneViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 4.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SceneViewModel {
    
    final let disposeBag = DisposeBag()
    
    let _errorRelay = PublishRelay<Error>()
    let errorReceived: Signal<(title: String, message: String)>
    
    init() {
        errorReceived = _errorRelay
            .asSignal()
            .map { error in
                guard let apiError = error as? APIConnectionError else {
                    return (title: "Опа", message: "😟 Нещо се обърка, пробвай пак по-късно.")
                }
                
                return (title: apiError.title, message: apiError.localizedDescription)
            }
    }
}
