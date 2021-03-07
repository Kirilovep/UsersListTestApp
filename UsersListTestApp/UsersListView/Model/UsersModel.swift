//
//  UsersModel.swift
//  UsersListTestApp
//
//  Created by shizo663 on 06.03.2021.
//

import Foundation

// MARK: - Welcome
struct UsersList: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: Name?
    let email: String?
    let phone: String?
    let picture: Picture?
}


// MARK: - Name
struct Name: Codable {
    let title, first, last: String?
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String?
}
