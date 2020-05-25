//
//  Coordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    
    func start()
    
    func finish()
    
    func openURL(_ url: URL)
}

extension Coordinator {
    
    func finish() {}
    
    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
