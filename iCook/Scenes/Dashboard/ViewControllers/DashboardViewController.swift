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
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quickButton.title = "Quick! Give me something random to eat!"
        suggestionButton.title = "Recommend me the best thing to eat."
        contributionButton.title = "Share a recipe or rate others!"
        
        quickButton.titleColorNormal = .accentDarker
        quickButton.titleColorSelected = .accentLighter
        quickButton.barColor = .accentDarker
        suggestionButton.titleColorNormal = .accentDarker
        suggestionButton.titleColorSelected = .accentLighter
        suggestionButton.barColor = .accentDarker
        contributionButton.titleColorNormal = .accentDarker
        contributionButton.titleColorSelected = .accentLighter
        contributionButton.barColor = .accentDarker
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
