//
//  User.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import Foundation

struct User: Decodable, Identifiable {
    var id: Int
    let name: String
    let htmlUrl: URL
    let avatarUrl: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}
