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
            HStack {
                Spacer()

                VStack(spacing: 12) {
                    UserThumbnailView(urlString: viewModel.userDetail.imageURLString, size: 80)

                    VStack(spacing: 2) {
                        Text(viewModel.userDetail.fullName ?? "-")
                            .font(.title)
                            .fontWeight(.bold)

                        Text(viewModel.userDetail.name)
                            .font(.title2)
                    }

                    HStack(spacing: 32) {
                        VStack {
                            Text("\(viewModel.userDetail.followerCount)")
                                .font(.title3)

                            Text("フォロワー数")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }

                        Divider()

                        VStack {
                            Text("\(viewModel.userDetail.followingCount)")
                                .font(.title3)

                            Text("フォロイー数")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .redacted(reason: viewModel.userDetail == UserDetail.empty() ? .placeholder : [])

                Spacer()
            }
            .padding()
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)

            if viewModel.hasNoRepositories {
                HStack {
                    Spacer()
                    Text("レポジトリは存在しません")
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .frame(minHeight: 100)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            } else {

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
                        .id(UUID())
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .onAppear {
                            viewModel.onScrollToBottom()
                        }
                }
            }
        }
        .listStyle(.plain)

        // レポジトリ詳細モーダル
        .sheet(item: $viewModel.presentingRepository, content: { repository in
            if let url = URL(string: repository.urlString) {
                SafariViewRepresentable(url: url)
            } else {
                // TODO: logging
                EmptyView()
            }
        })

        // error alert
        .alert("エラーが発生しました", isPresented: .constant(viewModel.fetchError != nil)) {
            Button("OK") {
                viewModel.fetchError = nil
            }
        } message: {
            Text(viewModel.fetchError?.localizedDescription ?? "原因不明のエラーが発生しました")
        }

        .task {
            await viewModel.onAppear()
        }
    }
}

struct UserDetailRepositoryView: View {

    let repository: Repository

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(repository.name)
                    .fontWeight(.bold)

                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star")
                        Text("\(repository.starCount)")
                    }
                    Text("/")
                    Text(repository.language ?? "-")
                }
                .font(.footnote)

                Text(repository.description ?? "-")
                    .font(.footnote)
                    .foregroundStyle(.gray)
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

