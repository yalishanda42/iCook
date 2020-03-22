//
//  KawaiiView.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

@IBDesignable
class KawaiiView: UIView {
    
    @IBInspectable var barColor: UIColor = .blue {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor = UIColor.gray.withAlphaComponent(0.5) {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var borderWidth: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var cornerRadius: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
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
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
