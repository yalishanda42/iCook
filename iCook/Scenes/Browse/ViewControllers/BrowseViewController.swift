//
//  BrowseViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BrowseViewController: SceneViewController<BrowseViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchTextField: KawaiiTextField!
    @IBOutlet private weak var noResultsView: UIView!
    @IBOutlet private weak var noResultsLabel: UILabel!
    @IBOutlet private weak var resultsTableView: UITableView!
    
    // MARK: - Setup
    
    override func setupBindings() {
        super.setupBindings()
        
        let output = viewModel.transform(BrowseViewModel.Input(
            searchTerm: searchTextField.textField.rx.text.orEmpty.asObservable()
        ))
        
        // TODO: Bind table view
        output.resultsAreHidden.drive(resultsTableView.rx.isHidden).disposed(by: disposeBag)
        output.noResultsViewsAreHidden.drive(noResultsView.rx.isHidden).disposed(by: disposeBag)
        output.noResultsText.drive(noResultsLabel.rx.text).disposed(by: disposeBag)
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
