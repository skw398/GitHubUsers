//
//  GitHubUsersApp.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import SwiftUI

@main
struct GitHubUsersApp: App {
    let repo = GitHubUsersRepositoryImpl()

    var body: some Scene {
        WindowGroup {
            TabView {
                UserListView(vm: UserListViewModelImplWithCombine(repo: repo))
                    .tabItem { Text("Combine") }

                UserListView(vm: UserListViewModelImplWithConcurrency(repo: repo))
                    .tabItem { Text("Concurrency") }
            }
        }
    }
}
