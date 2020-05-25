//
//  PickerViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 25.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        
        // TODO
    }
    
    @IBAction func onTapDoneButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
