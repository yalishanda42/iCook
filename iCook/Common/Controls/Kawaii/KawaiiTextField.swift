//
//  KawaiiTextField.swift
//  iCook
//
//  Created by Alexander Ignatov on 5.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

@IBDesignable
class KawaiiTextField: KawaiiView, XibLoadable {
    
    @IBOutlet private weak var textField: UITextField!
    
    var text: String {
        return textField.text ?? ""
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
}
