//
//  APIDishDataArrayResponse.swift
//  iCook
//
//  Created by Alexander Ignatov on 1.05.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

struct APIDishDataArrayResponse: APIResponse {
    let message: String
    let data: [DishData]
}
