//
//  StoryboardInstantiable.swift
//  iCook
//
//  Created by Alexander Ignatov on 18.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    static var storyboardName: String {
        return String(describing: self)
            .replacingOccurrences(of: "ViewController", with: "")
    }
    
    static var storyboardIdentifier: String { return String(describing: self) }
    
    static func instantiateFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
        }

        return viewController
    }
}

extension UIViewController: StoryboardInstantiable {}
