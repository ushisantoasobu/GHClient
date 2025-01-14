//
//  UserDetailScreen.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import SwiftUI

struct UserDetailScreen: View {

    init(userName: String) {
        self.viewModel = .init(userName: userName)
    }

    @ObservedObject private var viewModel: UserDetailViewModel

    var body: some View {
        List {
            if let userDetail = viewModel.userDetail {
                HStack {
                    Spacer()
                    VStack {
                        UserThumbnailView(urlString: userDetail.imageURLString, size: 80)

                        Text(userDetail.name)

                        Text(userDetail.fullName ?? "-")

                        HStack {
                            VStack {
                                Text("\(userDetail.followerCount)")
                                Text("フォロワー数")
                            }
                            VStack {
                                Text("\(userDetail.followingCount)")
                                Text("フォロイー数")
                            }
                        }
                    }

                    Spacer()
                }
            }

            ForEach(viewModel.repositories) { repository in
                Button {
                    viewModel.onRepositoryTapped(repository: repository)
                } label: {
                    UserDetailRepositoryView(repository: repository)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }

            if viewModel.hasNext {
                ListLoadingView()
                    .onAppear {
                        viewModel.onScrollToBottom()
                    }
            }
        }
        .listStyle(.plain)
        .sheet(item: $viewModel.presentingRepository, content: { repository in
            if let url = URL(string: repository.urlString) {
                SafariViewRepresentable(url: url)
            } else {
                // TODO: logging
                EmptyView()
            }
        })
        .task {
            await viewModel.onAppear()
        }
    }
}

struct UserDetailRepositoryView: View {

    let repository: Repository

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text(repository.name)

                HStack {
                    Text("\(repository.starCount)")
                    Text(repository.language ?? "-")
                }

                Text(repository.description ?? "-")
                    .lineLimit(2)
            }
            .padding()

            Divider()
        }
    }
}

#Preview {
    UserDetailScreen(userName: "hoge")
}

