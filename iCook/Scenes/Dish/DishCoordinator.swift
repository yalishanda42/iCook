//
//  DishCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class DishCoordinator: Coordinator {
    
    private let viewController: UIViewController
    private let services: ServiceDependencies
    
    private let navControllerWrapper: UINavigationController = {
        let result = UINavigationController()
        result.modalPresentationStyle = .fullScreen
        return result
    }()
    private lazy var dishViewController = DishViewController.instantiateFromStoryboard()
    
    init(in viewController: UIViewController, services: ServiceDependencies) {
        self.viewController = viewController
        self.services = services
    }
    
    func start() {
        navControllerWrapper.setViewControllers([dishViewController], animated: false)
        viewController.present(navControllerWrapper, animated: true, completion: nil)
    }
}
