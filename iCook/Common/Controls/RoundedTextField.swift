//
//  RoundedTextField.swift
//  iCook
//
//  Created by Alexander Ignatov on 5.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {
    
    override func awakeFromNib() {
        layer.cornerRadius = 12
    }
}
