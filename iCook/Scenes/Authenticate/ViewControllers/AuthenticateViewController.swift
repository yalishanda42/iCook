//
//  AuthenticateViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 5.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AuthenticateViewController: SceneViewController<AuthenticateViewModel> {

    // MARK: - Outlets
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstName: KawaiiTextField!
    @IBOutlet weak var familyName: KawaiiTextField!
    @IBOutlet weak var emailField: KawaiiTextField!
    @IBOutlet weak var passwordField: KawaiiTextField!
    @IBOutlet weak var repeatPasswordField: KawaiiTextField!
    @IBOutlet weak var registerButton: KawaiiButton!
    @IBOutlet weak var continueButton: KawaiiButton!
    @IBOutlet weak var namesStackView: UIStackView!
    
    // MARK: - Setup
    
    override func setupViews() {
        super.setupViews()
        navigationController?.isNavigationBarHidden = true
        passwordField.textField.isSecureTextEntry = true
        repeatPasswordField.textField.isSecureTextEntry = true
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        namesStackView.isHidden = viewModel.firstNameIsHidden && viewModel.familyNameIsHidden
        firstName.isHidden = viewModel.firstNameIsHidden
        familyName.isHidden = viewModel.familyNameIsHidden
        screenTitle.text = viewModel.screenTitleText
        repeatPasswordField.isHidden = viewModel.repeatPasswordFieldIsHidden
        registerButton.isHidden = viewModel.registerButtonIsHidden
        backButton.isHidden = viewModel.backButtonIsHidden
        
        viewModel.transform(AuthenticateViewModel.Input(
            firstNameText: firstName.textField.rx.text.orEmpty.asObservable(),
            familyNameText: familyName.textField.rx.text.orEmpty.asObservable(),
            emailText: emailField.textField.rx.text.orEmpty.asObservable(),
            passwordText: passwordField.textField.rx.text.orEmpty.asObservable(),
            passwordRepeatedText: repeatPasswordField.textField.rx.text.orEmpty.asObservable(),
            continueButtonTap: continueButton.button.rx.tap.asObservable(),
            goResgisterButtonTap: registerButton.button.rx.tap.asObservable(),
            goBackButtonTap: backButton.rx.tap.asObservable())
        )
    }
}
