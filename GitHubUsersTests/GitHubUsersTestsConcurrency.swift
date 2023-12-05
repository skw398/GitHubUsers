//
//  GitHubUsersTestsConcurrency.swift
//  GitHubUsersTests
//
//  Created by Shigenari Oshio on 2023/12/05.
//

import APIKit
@testable import GitHubUsers
import XCTest

@MainActor
final class GitHubUsersTestsConcurrency: XCTestCase {
    let mock = GitHubUsersRepositoryProtocolMock()

    func testFetchUsersSuccess() async throws {
        mock.concurrencyFetchUsersHandler = { _, _ async throws -> [User] in
            [User(
                id: 0,
                name: "skw398",
                htmlUrl: .init(string: "https://github.com/skw398")!,
                avatarUrl: .init(string: "https://avatars.githubusercontent.com/u/114917347?v=4")!
            )]
        }
        let model = UserListViewModelImplWithConcurrency(repo: mock)
        model.fetchUsers()

        // fetchUsers()の中でTask.init()をやっているためsleepしている。
        // Task.init()をViewでやって、ViewModelのfetchUsers()をasyncにすれば、
        // fetchUsers()をawaitできるためsleepしなくて良い。
        // ただTaskをViewで扱うのでキャンセルがやりずくなる。
        try await Task.sleep(nanoseconds: UInt64(0.2 * 1_000_000_000))

        XCTAssertEqual(mock.concurrencyFetchUsersHandlerCallCount, 1)
        XCTAssertEqual(model.users.count, 1)
    }

    func testFetchUsersFailure() async throws {
        mock.concurrencyFetchUsersHandler = { _, _ in
            throw SessionTaskError.connectionError(NSError())
        }
        let model = UserListViewModelImplWithConcurrency(repo: mock)
        model.fetchUsers()

        try await Task.sleep(nanoseconds: UInt64(0.2 * 1_000_000_000))

        XCTAssertEqual(mock.concurrencyFetchUsersHandlerCallCount, 1)
        XCTAssertTrue(model.showError.isShowing)
    }
}
