//
//  DishService.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

protocol DishService {
    
    func generateNewQuickRandomDishSuggestion(completion: @escaping (_ dishId: Int) -> Void)
    
    func fetchDishInfo(for dishId: Int, completion: @escaping (Dish) -> Void)
    
}
