//
//  UserListViewModel.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import Combine
import Foundation

class BaseUserListViewModel<TaskType> {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var showError: (isShowing: Bool, message: String) = (false, "")

    var fetchUsersTask: TaskType?

    let repo: GitHubUsersRepositoryProtocol

    init(repo: GitHubUsersRepositoryProtocol) {
        self.repo = repo
    }
}

final class CombineUserListViewModel: BaseUserListViewModel<AnyCancellable>, UserListViewModelProtocol {
    var navigationTitle: String = "Combine"

    func fetchUsers() {
        isLoading = true

        fetchUsersTask?.cancel()
        fetchUsersTask = repo.fetchUsers(userCount: 20, startId: users.last?.id ?? 0)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }

                    switch completion {
                    case .finished: break
                    case let .failure(error):
                        self.isLoading = false
                        self.showError = (true, error.localizedDescription)
                    }
                }, receiveValue: { [weak self] users in
                    guard let self else { return }

                    self.isLoading = false
                    self.users += users
                }
            )
    }
}

@MainActor
final class ConcurrencyUserListViewModel: BaseUserListViewModel<Task<Void, Error>>, UserListViewModelProtocol {
    var navigationTitle: String = "Concurrency"

    func fetchUsers() {
        isLoading = true

        fetchUsersTask?.cancel()
        fetchUsersTask = Task {
            defer { isLoading = false }

            do {
                let users = try await repo.fetchUsers(userCount: 20, startId: users.last?.id ?? 0)
                self.users += users
            } catch {
                self.showError = (true, error.localizedDescription)
            }
        }
    }
}
