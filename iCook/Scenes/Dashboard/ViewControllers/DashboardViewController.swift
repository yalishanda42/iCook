//
//  DashboardViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var quickButton: KawaiiButton!
    @IBOutlet private weak var suggestionButton: KawaiiButton!
    @IBOutlet private weak var contributionButton: KawaiiButton!
    
    // MARK: - Properties
    
    var viewModel: DashboardViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quickButton.onTap = { [weak self] in
            self?.viewModel.quickRecommendationCommand()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
