//
//  APIUserDataResponse.swift
//  iCook
//
//  Created by Alexander Ignatov on 10.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

struct APIUserDataResponse: APIResponse, Codable {
    let message: String
    let data: UserData
}
