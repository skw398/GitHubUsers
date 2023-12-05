//
//  UserListView.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import Combine
import SwiftUI

struct UserListView<ViewModel: UserListViewModelProtocol>: View {
    @StateObject var vm: ViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.users) { user in

                    NavigationLink {
                        WebView(url: user.htmlUrl)
                            .navigationBarTitle(user.name, displayMode: .inline)
                    } label: {
                        UserListCellView(user: user)
                            .frame(height: 50)
                            .onAppear {
                                if user.id == vm.users.last?.id {
                                    vm.fetchUsers()
                                }
                            }
                    }
                }

                if vm.isLoading {
                    Text("Loading...")
                }
            }
            .onAppear {
                vm.fetchUsers()
            }
            .refreshable {
                vm.users = []
                vm.fetchUsers()
            }
            .alert("エラーが発生しました。", isPresented: $vm.showError.isShowing) {
                Text("OK")
            } message: {
                Text(vm.showError.message)
            }
            .listStyle(.plain)
            .navigationBarTitle(vm.navigationTitle)
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        let repo = GitHubUsersRepositoryImpl()

        TabView {
            UserListView(vm: UserListViewModelImplWithCombine(repo: repo))
                .tabItem { Text("Combine") }

            UserListView(vm: UserListViewModelImplWithConcurrency(repo: repo))
                .tabItem { Text("Concurrency") }
        }
    }
}
