//
//  UserListViewModel.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import Combine
import Foundation

final class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var showError: (isShowing: Bool, message: String) = (false, "")

    private let repo: GitHubUsersRepositoryProtocol
    private var fetchUsersTask: AnyCancellable? = nil

    init(repo: GitHubUsersRepositoryProtocol) {
        self.repo = repo
    }

    func fetchUsers() {
        isLoading = true

        fetchUsersTask?.cancel()
        fetchUsersTask = repo.fetchUsers(userCount: 20, startId: users.last?.id ?? 0)
//            .delay(for: .seconds(0.5), scheduler: RunLoop.main) // デバッグ
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
