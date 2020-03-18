//
//  AppCoordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow?
    var child: Coordinator?
    
    lazy var apiService: APIService = TestAPIService()
    
    init(in window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        guard let window = window else { return }
        
        let rootViewController = UINavigationController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        let login = LoginCoordinator(rootViewController, apiService: apiService)
        child = login
        login.start()
    }
}
