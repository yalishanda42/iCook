//
//  SettingsViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class SettingsViewController: SceneViewController<SettingsViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var namesLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var logOutlogInButton: UIButton!
    
    // MARK: - Setup
    
    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(SettingsViewModel.Input(
            userButtonTap: logOutlogInButton.rx.tap.asObservable(),
            viewDidAppear: rx.viewDidAppear.map{ _ in }.asObservable()
        ))
        
        output.namesText.drive(namesLabel.rx.text).disposed(by: disposeBag)
        output.emailText.drive(emailLabel.rx.text).disposed(by: disposeBag)
        output.userButtonText.drive(logOutlogInButton.rx.title()).disposed(by: disposeBag)
        output.namesAreHidden.drive(namesLabel.rx.isHidden).disposed(by: disposeBag)
        output.emailIsHidden.drive(emailLabel.rx.isHidden).disposed(by: disposeBag)
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.setNavigationBarHidden(true, animated: animated)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       navigationController?.setNavigationBarHidden(false, animated: animated)
   }
}
