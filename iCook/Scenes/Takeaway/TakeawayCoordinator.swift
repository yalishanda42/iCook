//
//  TakeawayCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 25.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class TakeawayCoordinator: Coordinator {
    
    private let parentViewController: UIViewController
    private let services: ServiceDependencies
    
    private lazy var navControllerWrapper: UINavigationController = {
        let result = UINavigationController(rootViewController: takeawayViewController)
        result.modalPresentationStyle = .pageSheet
        return result
    }()
    
    private lazy var takeawayViewController: TakeawayViewController = {
        let result = TakeawayViewController.instantiateFromStoryboard()
        result.viewModel = viewModel
        return result
    }()
    
    private lazy var viewModel: TakeawayViewModel = {
        let result = TakeawayViewModel()
        result.coordinatorDelegate = self
        return result
    }()
    
    init(in parentViewController: UIViewController, services: ServiceDependencies) {
        self.parentViewController = parentViewController
        self.services = services
    }
    
    func start() {
        parentViewController.present(navControllerWrapper, animated: true, completion: nil)
    }
    
    func finish() {
        navControllerWrapper.dismiss(animated: true, completion: nil)
    }
}
