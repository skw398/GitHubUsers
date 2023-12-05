//
//  GitHubUsersApp.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import SwiftUI

@main
struct GitHubUsersApp: App {
    let repo = GitHubUsersRepository()

    var body: some Scene {
        WindowGroup {
            TabView {
                UserListView(vm: CombineUserListViewModel(repo: repo))
                    .tabItem { Text("Combine") }

                UserListView(vm: ConcurrencyUserListViewModel(repo: repo))
                    .tabItem { Text("Concurrency") }
            }
        }
    }
}
