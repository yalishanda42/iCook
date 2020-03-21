//
//  AuthenticateViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 5.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class AuthenticateViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var emailField: KawaiiTextField!
    @IBOutlet weak var passwordField: KawaiiTextField!
    @IBOutlet weak var repeatPasswordField: KawaiiTextField!
    @IBOutlet weak var registerButton: KawaiiButton!
    @IBOutlet weak var continueButton: KawaiiButton!
    
    // MARK: - Properties
    
    var viewModel: AuthenticateViewModel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.textField.placeholder = "E-mail"
        passwordField.textField.placeholder = "Password"
        repeatPasswordField.textField.placeholder = "Repeat password"
        registerButton.title = "Don't have an account? Sign up!"
        continueButton.title = "Let's eat!"
        
        passwordField.textField.isSecureTextEntry = true
        repeatPasswordField.textField.isSecureTextEntry = true
        
        emailField.barColor = .deepPurple
        passwordField.barColor = .deepPurple
        repeatPasswordField.barColor = .deepPurple
        registerButton.barColor  = .accentLighter
        registerButton.titleColorNormal = .accentLighter
        continueButton.barColor = .accentLighter
        continueButton.titleColorNormal = .accentLighter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch viewModel.type {
        case .login:
            repeatPasswordField.isHidden = true
            registerButton.isHidden = false
            navigationController?.setToolbarHidden(true, animated: animated)
        case .register:
            repeatPasswordField.isHidden = false
            registerButton.isHidden = true
            navigationController?.setToolbarHidden(false, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if viewModel.type == .login {
            navigationController?.setToolbarHidden(false, animated: animated)
        }
    }
    
    // MARK: - Actions
    
    @objc func onTapContinueButton(_ sender: Any) {
        viewModel.loginCommand(email: emailField.text, password: passwordField.text)
    }
}

