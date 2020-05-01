//
//  SearchService.swift
//  iCook
//
//  Created by Alexander Ignatov on 1.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchService {
    
    func search(for searchTerm: String) -> Observable<[Dish]>
    
}
