//
//  FakeDishService.swift
//  iCook
//
//  Created by Alexander Ignatov on 22.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation
import RxSwift

class FakeDishService: DishService {
    
    func generateNewQuickRandomDishSuggestion() -> Observable<Int> {
        return Observable.just(8888)
    }
    
    func fetchDishInfo(for dishId: Int) -> Observable<Dish> {
        return Observable.just(Dish(
            name: "Baklava",
            imageUrl: "https://us.123rf.com/450wm/hayatikayhan/hayatikayhan1901/hayatikayhan190101187/116429036-traditional-delicious-turkish-baklava-with-pistachio-nuts-.jpg?ver=6",
            recipeOverviews: [
                RecipeOverviewInfo(
                    id: 1,
                    dishId: dishId,
                    authorNames: "Alexander Ignatov",
                    authorEmail: "yalishanda@abv.bg",
                    dateAdded: 1584662400,
                    commentsCount: 0,
                    rating: 0.0
                ),
                RecipeOverviewInfo(
                    id: 2,
                    dishId: dishId,
                    authorNames: "Hristo Stoichkov",
                    authorEmail: "fiftyfifty@winbet.losebet.bg",
                    dateAdded: 1584652400,
                    commentsCount: 8,
                    rating: 1.7
                ),
                RecipeOverviewInfo(
                    id: 3,
                    dishId: dishId,
                    authorNames: "Gordon Ramsey",
                    authorEmail: "youfkingdonkey@bestcook.co.uk",
                    dateAdded: 1584602400,
                    commentsCount: 420,
                    rating: 8.3
                ),
                RecipeOverviewInfo(
                    id: 4,
                    dishId: dishId,
                    authorNames: "Bat Nasko",
                    authorEmail: "naskonasko@interferenciq.bg",
                    dateAdded: 1584562400,
                    commentsCount: 3,
                    rating: 9.2
                ),
                RecipeOverviewInfo(
                    id: 5,
                    dishId: dishId,
                    authorNames: "Pesho Baftata",
                    authorEmail: "baftata420@nmp.com",
                    dateAdded: 1662400,
                    commentsCount: 69,
                    rating: 10
                ),
            ]
        ))
    }
}
