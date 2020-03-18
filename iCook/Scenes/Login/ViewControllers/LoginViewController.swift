//
//  LoginViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 5.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var firstField: RoundedTextField!
    @IBOutlet weak var secondField: RoundedTextField!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    
    var viewModel: LoginViewModel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func onTapContinueButton(_ sender: Any) {
        guard let email = firstField.text,
            let password = secondField.text
        else {
            return
        }
        
        viewModel.loginCommand(email: email, password: password)
    }
}

