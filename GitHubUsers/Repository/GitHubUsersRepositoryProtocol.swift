//
//  GitHubUsersRepositoryProtocol.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/02.
//

import APIKit
import Combine

/// @mockable
protocol GitHubUsersRepositoryProtocol {
    func fetchUsers(userCount: Int, startId: Int) -> Future<[User], SessionTaskError>
}
