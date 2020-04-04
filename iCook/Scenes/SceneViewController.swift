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
    
    private var loadingIndicator: UIActivityIndicatorView?
    private var isLoading = false {
        didSet {
            if isLoading && loadingIndicator == nil {
                let indicator = UIActivityIndicatorView(style: .large)
                view.addSubview(indicator)
                indicator.translatesAutoresizingMaskIntoConstraints = false
                indicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                indicator.startAnimating()
                loadingIndicator = indicator
            } else if !isLoading {
                loadingIndicator?.stopAnimating()
                loadingIndicator = nil
            }
        }
    }
    
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
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.isLoading = isLoading
            }).disposed(by: disposeBag)
    }
}
