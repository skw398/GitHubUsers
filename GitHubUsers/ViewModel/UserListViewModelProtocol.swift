//
//  UserListViewModelProtocol.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/05.
//

import Combine

@MainActor
protocol UserListViewModelProtocol: ObservableObject {
    var users: [User] { get set }
    var isLoading: Bool { get }
    var showError: (isShowing: Bool, message: String) { get set }
    var navigationTitle: String { get }

    func fetchUsers()
}
