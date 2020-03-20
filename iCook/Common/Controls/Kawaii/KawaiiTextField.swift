//
//  KawaiiTextField.swift
//  iCook
//
//  Created by Alexander Ignatov on 5.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

@IBDesignable
class KawaiiTextField: UIView, XibLoadable {
    
    @IBOutlet weak var textField: UITextField!
    
    var text: String {
        return textField.text ?? ""
    }
    
    private let barColor = UIColor(named: "deep-purple")!
    private let borderColor = UIColor(named: "mediumgrey")!.withAlphaComponent(0.5)
    private let borderWidth: CGFloat = 1
    private let cornerRadius: CGFloat = 10
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        let bar = UIBezierPath(rect: CGRect(
            x: 0,
            y: 0,
            width: cornerRadius,
            height: bounds.height
        ))
        barColor.setFill()
        bar.fill()
        context?.restoreGState()
    }
    
    override func awakeFromNib() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
}
