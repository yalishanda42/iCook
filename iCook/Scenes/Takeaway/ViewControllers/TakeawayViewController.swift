//
//  TakeawayViewController.swift
//  iCook
//
//  Created by Alexander Ignatov on 25.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

class TakeawayViewController: SceneViewController<TakeawayViewModel> {
    
    @IBOutlet private weak var takeawayComButton: KawaiiButton!
    @IBOutlet private weak var foodpandaBgButton: KawaiiButton!
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        viewModel.transform(TakeawayViewModel.Input(
            onTapTakeaway: takeawayComButton.button.rx.tap.asObservable(),
            onTapFoodpanda: foodpandaBgButton.button.rx.tap.asObservable()
        ))
    }
}
