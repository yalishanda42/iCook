//
//  CommentsCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 28.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class CommentsCoordinator: Coordinator {

    private let parentViewController: UIViewController
    private let services: ServiceDependencies

    private lazy var navControllerWrapper: UINavigationController = {
        let result = UINavigationController(rootViewController: viewController)
        result.modalPresentationStyle = .automatic
        return result
    }()

    private lazy var viewController: CommentsViewController = {
        let result = CommentsViewController.instantiateFromStoryboard()
        result.viewModel = viewModel
        return result
    }()

    private lazy var viewModel: CommentsViewModel = {
        let result = CommentsViewModel()
        result.coordinatorDelegate = self
        return result
    }()

    init(in parentViewController: UIViewController, services: ServiceDependencies) {
        self.parentViewController = parentViewController
        self.services = services
    }

    func start() {
        parentViewController.present(navControllerWrapper, animated: true)
    }

    func finish() {
        navControllerWrapper.dismiss(animated: true, completion: nil)
    }
}
