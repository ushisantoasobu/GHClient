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
        VStack(alignment: .leading) {
            Text(repository.name)

            HStack {
                Text("\(repository.starCount)")
                Text(repository.language ?? "-")
            }

            Text(repository.description ?? "-")
                .lineLimit(2)
        }
    }
}

#Preview {
    UserDetailScreen(userName: "hoge")
}

@MainActor
class UserDetailViewModel: ObservableObject {

    @Published var userDetail: UserDetail?
    @Published var repositories: [Repository] = []
    @Published var hasNext = false

    @Published var presentingRepository: Repository?

    private let userName: String
    private let userDetailRepository: any UserDetailRepository
    private let repoRepository: any RepoRepository

    private var page: Int = 1

    init(
        userName: String,
        userDetailRepository: any UserDetailRepository = UserDetailRepositoryImpl(),
        repoRepository: any RepoRepository = RepoRepositoryImpl()
    ) {
        self.userName = userName
        self.userDetailRepository = userDetailRepository
        self.repoRepository = repoRepository
    }

    func onAppear() async {
        await fetchInitially()
    }

    func onScrollToBottom() {
        Task {
            await fetchRepositories()
        }
    }

    func onRepositoryTapped(repository: Repository) {
        presentingRepository = repository
    }

    private func fetchInitially() async {
        do {
            async let userDetail = try await userDetailRepository.fetch(userName: userName)
            async let repositories = try await repoRepository.fetch(userName: userName, page: page)

            self.userDetail = try await userDetail

            let repositoriesResponse = try await repositories
            self.repositories = repositoriesResponse.list
            hasNext = repositoriesResponse.hasNext
            page += 1
        } catch {
            // TODO
            print("userDetailAPI: \(error)")
        }
    }

    private func fetchRepositories() async {
        do {
            let repositoriesResponse = try await repoRepository.fetch(userName: userName, page: page)
            self.repositories.append(contentsOf: repositoriesResponse.list)
            hasNext = repositoriesResponse.hasNext
            page += 1
        } catch {
            // TODO
            print("userDetailAPI: \(error)")
        }
    }
}
