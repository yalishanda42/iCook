//
//  Observable+extensions.swift
//  iCook
//
//  Created by Alexander Ignatov on 19.06.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import RxSwift
import RxCocoa

extension Observable {
    func catchErrorPublishAndReturnEmpty(toRelay relay: PublishRelay<Error>) -> Observable<Element> {
        return catchError { error in
            relay.accept(error)
            return .empty()
        }
    }
    
    func asDriverIgnoringError() -> Driver<Element> {
        return asDriver(onErrorDriveWith: .empty())
    }
}
