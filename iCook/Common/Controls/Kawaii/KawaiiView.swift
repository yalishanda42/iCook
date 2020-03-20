//
//  KawaiiView.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class KawaiiView: UIView {
    
    var barColor: UIColor = .blue {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var borderColor = UIColor.gray.withAlphaComponent(0.5) {
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
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        addShadow()
    }
    
    private func addShadow() {
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: bounds.height))
        shadowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        shadowPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        
        let shadowContainerView = UIView()
        shadowContainerView.backgroundColor = .clear
        addSubview(shadowContainerView)
        shadowContainerView.clipsToBounds = false
        shadowContainerView.layer.shadowColor = UIColor.gray.cgColor
        shadowContainerView.layer.shadowOpacity = 0.33
        shadowContainerView.layer.shadowOffset = .zero
        shadowContainerView.layer.shadowRadius = 20
        shadowContainerView.layer.shadowPath = shadowPath.cgPath
        shadowContainerView.translatesAutoresizingMaskIntoConstraints = false
        shadowContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        shadowContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        shadowContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        shadowContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
