//
//  Token+CoreDataProperties.swift
//  iCook
//
//  Created by Alexander Ignatov on 12.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//
//

import Foundation
import CoreData

extension Token {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Token> {
        return NSFetchRequest<Token>(entityName: "Token")
    }

    @NSManaged public var bearer: String

}
