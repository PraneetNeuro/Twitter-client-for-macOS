//
//  UsersModal.swift
//  Twitter
//
//  Created by Praneet S on 18/02/21.
//

import Foundation

struct UserSearchResponse: Codable {
    let data: [TwitterUser]
}

struct userLookup: Codable {
    let data: TwitterUser
}

struct TwitterUser: Codable {
    let id: String
    let name: String
    let username: String
    let profile_image_url: String
    let verified: Bool
}
