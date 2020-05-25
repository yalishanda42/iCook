//
//  PickerViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 25.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    
    // MARK: - Properties
    
    var data: [String]!
    var selectedValueIndex: Int!
    var callback: ((Int) -> Void)?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func onTapDoneButton(_ sender: Any) {
        dismiss(animated: true)
        callback?(selectedValueIndex)
    }
}

// MARK: - PickerView Data Source

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        data.count
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        data[row]
    }
}


// MARK: - PickerView Delegate

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        selectedValueIndex = row
    }
}
