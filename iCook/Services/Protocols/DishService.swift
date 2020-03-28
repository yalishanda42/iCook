//
//  DishService.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

protocol DishService {
    
    func generateNewQuickRandomDishSuggestion() -> Observable<Int>
    
    func fetchDishInfo(for dishId: Int) -> Observable<Dish>
    
}
