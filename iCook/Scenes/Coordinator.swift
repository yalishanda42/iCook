//
//  Coordinator.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

protocol Coordinator {
    func start()
    func finish()
}

extension Coordinator {
    func finish() {}
}
