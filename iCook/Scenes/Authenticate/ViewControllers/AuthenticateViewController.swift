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

class AuthenticateViewController: UIViewController {

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
    
    // MARK: - Properties
    
    var viewModel: AuthenticateViewModel!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
}

// MARK: - Helpers
    
private extension AuthenticateViewController {
    func setupViews() {
        navigationController?.isNavigationBarHidden = true
        passwordField.textField.isSecureTextEntry = true
        repeatPasswordField.textField.isSecureTextEntry = true
    }
    
    func setupBindings() {
        namesStackView.isHidden = viewModel.firstNameIsHidden && viewModel.familyNameIsHidden
        firstName.isHidden = viewModel.firstNameIsHidden
        familyName.isHidden = viewModel.familyNameIsHidden
        screenTitle.text = viewModel.screenTitleText
        repeatPasswordField.isHidden = viewModel.repeatPasswordFieldIsHidden
        registerButton.isHidden = viewModel.registerButtonIsHidden
        backButton.isHidden = viewModel.backButtonIsHidden
        
        firstName.textField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.firstName)
            .disposed(by: disposeBag)
        
        familyName.textField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.familyName)
            .disposed(by: disposeBag)
        
        emailField.textField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordField.textField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        repeatPasswordField.textField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.passwordRepeated)
            .disposed(by: disposeBag)

        continueButton.button.rx.tap
            .bind(onNext: viewModel.continueCommand)
            .disposed(by: disposeBag)
        
        registerButton.button.rx.tap
            .bind(onNext: viewModel.goRegisterCommand)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(onNext: viewModel.goBackCommand)
            .disposed(by: disposeBag)
    }
}

