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
    @IBOutlet weak var backButton: UIButton!
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
        
        navigationController?.isToolbarHidden = true
        
        switch viewModel.type {
        case .login:
            screenTitle.text = "Login"
            repeatPasswordField.isHidden = true
            registerButton.isHidden = false
            backButton.isHidden = true
        case .register:
            screenTitle.text = "Register"
            repeatPasswordField.isHidden = false
            registerButton.isHidden = true
            backButton.isHidden = false
        }
        
        continueButton.onTap = { [weak self] in
            self?.onTapContinueButton()
        }
        
        registerButton.onTap = { [weak self] in
            self?.onTapGoRegisterButton()
        }
        
        backButton.addTarget(self, action: #selector(onTapBackButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    func onTapContinueButton() {
        viewModel.continueCommand(
            // TODO: Use RxSwift's two-way binding
            email: emailField.text,
            password: passwordField.text,
            repeatedPassword: repeatPasswordField.text
        )
    }
    
    func onTapGoRegisterButton() {
        viewModel.goRegisterCommand()
    }
    
    @objc func onTapBackButton() {
        viewModel.goBackCommand()
    }
}

