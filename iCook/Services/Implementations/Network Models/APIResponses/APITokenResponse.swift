//
//  APITokenResponse.swift
//  iCook
//
//  Created by Alexander Ignatov on 6.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import Foundation

struct APITokenResponse: Codable {
    let message: String
    let token: String?
}
