//
//  UserListCellView.swift
//  GitHubUsers
//
//  Created by Shigenari Oshio on 2023/12/01.
//

import Kingfisher
import SwiftUI

struct UserListCellView: View {
    let user: User

    var body: some View {
        HStack(spacing: 16) {
            KFImage(user.avatarUrl)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                Text(user.htmlUrl.description)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }
}

struct UserListCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserListCellView(user: .init(
            id: 0,
            name: "skw398",
            htmlUrl: .init(string: "https://github.com/skw398")!,
            avatarUrl: .init(string: "https://avatars.githubusercontent.com/u/114917347?v=4")!
        ))
        .frame(height: 50)
    }
}
