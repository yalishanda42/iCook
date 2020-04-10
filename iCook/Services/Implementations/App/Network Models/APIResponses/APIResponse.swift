//
//  APIResponse.swift
//  iCook
//
//  Created by Alexander Ignatov on 4.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

protocol APIResponse: Codable {
    var message: String { get }
}
