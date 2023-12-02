//
//  GitHubUsersRepository.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import APIKit
import Combine

final class GitHubUsersRepository: GitHubUsersRepositoryProtocol {
    private var request = GitHubUsersRequest()

    func fetchUsers(userCount: Int, startId: Int) -> Future<[User], SessionTaskError> {
        request.setQuery(since: startId, perPage: userCount)

        return .init { [weak self] promise in
            guard let self else { return }

            Session.send(self.request) { result in
                promise(result)
            }
        }
    }
}
