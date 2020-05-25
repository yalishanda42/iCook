//
//  TakeawayViewModel.swift
//  iCook
//
//  Created by Alexander Ignatov on 25.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class TakeawayViewModel: SceneViewModel {
    weak var coordinatorDelegate: Coordinator?
}

extension TakeawayViewModel {
    enum Provider: String {
        case takeaway = "https://takeaway.com"
        case foodpanda = "https://foodpanda.com"
    }
}

extension TakeawayViewModel: IOTransformable {
    struct Input {
        let onTapTakeaway: Observable<Void>
        let onTapFoodpanda: Observable<Void>
    }
    
    func transform(_ input: Input) -> Void {
        input.onTapTakeaway.subscribe(onNext: openTakeaway).disposed(by: disposeBag)
        input.onTapFoodpanda.subscribe(onNext: openFoodpanda).disposed(by: disposeBag)
    }
}

private extension TakeawayViewModel {
    func goBack() {
        coordinatorDelegate?.finish()
    }
    
    func openTakeaway() {
        openUrl(ofProvider: .takeaway)
    }
    
    func openFoodpanda() {
        openUrl(ofProvider: .foodpanda)
    }
    
    func openUrl(ofProvider provider: Provider) {
        guard let url = URL(string: provider.rawValue) else {
            fatalError("invalid provider url! (\(provider.rawValue)")
        }
        
        coordinatorDelegate?.openURL(url)
    }
}
