//
//  SceneViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 4.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SceneViewController<VM: SceneViewModel>: UIViewController {
    
    /// The ViewModel of the View. Must be set before the lifecycle methods are invoked.
    var viewModel: VM!
        
    final let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
    /// Called as the first part of viewDidLoad. Setup the UI views here before the bindings are done. Always call super.
    func setupViews() {
    }
    
    /// Called as the second part of viewDidLoad. Setup the bindings with the ViewModel here. Always call super.
    func setupBindings() {
        viewModel.errorReceived.drive(onNext: { [unowned self] title, message in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
