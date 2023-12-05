//
//  GitHubUsersTestsCombine.swift
//  GitHubUsersTests
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import APIKit
import Combine
@testable import GitHubUsers
import XCTest

@MainActor
final class GitHubUsersTestsCombine: XCTestCase {
    var mock = GitHubUsersRepositoryProtocolMock()

    func testFetchUsersSuccess() throws {
        mock.combineFetchUsersHandler = { _, _ in
            Future<[User], SessionTaskError> { promise in
                promise(.success(
                    [.init(
                        id: 0,
                        name: "skw398",
                        htmlUrl: .init(string: "https://github.com/skw398")!,
                        avatarUrl: .init(string: "https://avatars.githubusercontent.com/u/114917347?v=4")!
                    )]
                ))
            }
        }
        let model = CombineUserListViewModel(repo: mock)
        model.fetchUsers()

        XCTAssertEqual(mock.combineFetchUsersCallCount, 1)
        XCTAssertEqual(model.users.count, 1)
    }

    func testFetchUsersFailure() throws {
        mock.combineFetchUsersHandler = { _, _ in
            Future<[User], SessionTaskError> { promise in
                promise(.failure(.connectionError(NSError())))
            }
        }
        let model = CombineUserListViewModel(repo: mock)
        model.fetchUsers()

        XCTAssertEqual(mock.combineFetchUsersCallCount, 1)
        XCTAssertTrue(model.showError.isShowing)
    }
}
