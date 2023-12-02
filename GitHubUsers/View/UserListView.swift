//
//  UserListView.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import Combine
import SwiftUI

struct UserListView: View {
    @StateObject var vm = UserListViewModel(repo: GitHubUsersRepository())

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
            .navigationBarTitle("GitHub Users")
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
