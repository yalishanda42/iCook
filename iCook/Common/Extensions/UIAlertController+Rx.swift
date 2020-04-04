//
//  UIAlertController+Rx.swift
//  iCook
//
//  Created by Alexander Ignatov on 4.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxSwift

protocol RxAlertActionType {
    associatedtype Result

    var title: String? { get }
    var style: UIAlertAction.Style { get }
    var result: Result { get }
}

struct RxAlertAction<R>: RxAlertActionType {
    typealias Result = R

    let title: String?
    let style: UIAlertAction.Style
    let result: R
}

struct RxDefaultAlertAction: RxAlertActionType {
    typealias Result = RxAlertControllerResult

    let title: String?
    let style: UIAlertAction.Style
    let result: Result
}

enum RxAlertControllerResult {
    case ok
    case cancel
    case delete
}

extension UIAlertController {
    static func rxPresentAlert<Action: RxAlertActionType, Result>(
        inViewController viewController: UIViewController,
        title: String,
        message: String,
        actions: [Action],
        preferredStyle: UIAlertController.Style = .alert,
        animated: Bool = true
    ) -> Observable<Result> where Action.Result == Result {
        return Observable.create { observer -> Disposable in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

            actions.map { rxAction in
                UIAlertAction(title: rxAction.title, style: rxAction.style, handler: { _ in
                    observer.onNext(rxAction.result)
                    observer.onCompleted()
                })
            }.forEach(alertController.addAction)

            viewController.present(alertController, animated: animated, completion: nil)

            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }.debug()
    }
}
