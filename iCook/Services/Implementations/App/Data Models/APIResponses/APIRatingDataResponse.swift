//
//  APIRatingDataResponse.swift
//  iCook
//
//  Created by Alexander Ignatov on 20.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

struct APIRatingDataResponse: APIResponse {
    let message: String
    let data: RatingData
}
