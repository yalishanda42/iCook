//
//  UserData.swift
//  iCook
//
//  Created by Alexander Ignatov on 10.04.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

struct UserData: Codable {
    let id: Int
    let firstname: String
    let lastname: String
    let email: String
}

extension UserData {
    func asDomainUserModel() -> User {
        return User(firstName: firstname, familyName: lastname, email: email)
    }
}
