//
//  IOTransformable.swift
//  iCook
//
//  Created by Alexander Ignatov on 4.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

protocol IOTransformable {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
