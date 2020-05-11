//
//  DashboardViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit
import RxCocoa

class DashboardViewController: SceneViewController<DashboardViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var quickButton: KawaiiButton!
    @IBOutlet private weak var suggestionButton: KawaiiButton!
    @IBOutlet private weak var contributionButton: KawaiiButton!

    // MARK: - Setup
    
    override func setupBindings() {
        super.setupBindings()
        viewModel.transform(DashboardViewModel.Input(
            quickRecommendationButtonTap: quickButton.button.rx.tap.asObservable(),
            regularRecommendationButtonTap: suggestionButton.button.rx.tap.asObservable(),
            rateRecipesButtonTap: contributionButton.button.rx.tap.asObservable()
        ))
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
