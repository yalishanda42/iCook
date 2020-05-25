//
//  RecommendationViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 25.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

/*
 * This is a test implementation of the viewcontroller for the recommendation scene,
 * developed so as to show an example design of the page.
 */
class RecommendationViewController: SceneViewController<RecommendationViewModel> {
    
    // MARK: - Outlets

    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    // MARK: - Setup
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        viewModel.transform(RecommendationViewModel.Input(generateButtonTap: doneButton.rx.tap.asObservable()))
    }

}
