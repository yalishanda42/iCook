//
//  FakeSearchService.swift
//  iCook
//
//  Created by Alexander Ignatov on 1.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class FakeSearchService: SearchService {
    func search(for searchTerm: String) -> Observable<[Dish]> {
        let models = [
            Dish(name: "Пица с боб", imageUrl: "https://gradcontent.com/lib/250x250/pizza52.jpg", recipeOverviews: []),
            Dish(name: "Бобена чорба", imageUrl: "https://www.supichka.com/files/images/1554/resize_536_2000.jpg", recipeOverviews: [])
        ]
        return Observable.just(models)
    }
}
