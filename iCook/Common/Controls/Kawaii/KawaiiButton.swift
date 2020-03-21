//
//  KawaiiButton.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

@IBDesignable
class KawaiiButton: KawaiiView, XibLoadable {

    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var buttonLeadingContraint: NSLayoutConstraint!
    
    var onTap: (() -> Void)?
    
    var title: String {
        get {
            return button.title(for: .normal) ?? ""
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }
    
    var titleColorNormal: UIColor = .blue {
        didSet {
            button.setTitleColor(titleColorNormal, for: .normal)
        }
    }
    
    var titleColorSelected = UIColor.blue.withAlphaComponent(0.5) {
        didSet {
            button.setTitleColor(titleColorSelected, for: .selected)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonLeadingContraint.constant = cornerRadius
        button.addTarget(self, action: #selector(onTapButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc func onTapButtonAction(_ sender: Any) {
        onTap?()
    }
}
