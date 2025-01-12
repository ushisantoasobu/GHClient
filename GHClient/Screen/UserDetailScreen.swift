//
//  UserDetailScreen.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import SwiftUI

struct UserDetailScreen: View {

    init(userID: Int) {
        self.viewModel = .init(userID: userID)
    }

    @ObservedObject private var viewModel: UserDetailViewModel

    var body: some View {
        List {
            if let userDetail = viewModel.userDetail {
                HStack {
                    Spacer()
                    VStack {
                        if let url = URL(string: userDetail.imageURLString) {
                            AsyncImage(url: url)
                                .frame(width: 80, height: 80)
                                .clipped()
                        } else {
                            
                        }

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
                Text(repository.language)
            }

            Text(repository.description)
                .lineLimit(2)
        }
    }
}

#Preview {
    UserDetailScreen(userID: 1)
}

class UserDetailViewModel: ObservableObject {

    @Published var userDetail: UserDetail?
    @Published var repositories: [Repository] = []

    @Published var presentingRepository: Repository?

    private let userID: Int
    private let userRepository: any UserRepository
    private let repoRepository: any RepoRepository

    init(
        userID: Int,
        userRepository: any UserRepository = UserRepoRepositoryImpl(),
        repoRepository: any RepoRepository = MockRepoRepository()
    ) {
        self.userID = userID
        self.userRepository = userRepository
        self.repoRepository = repoRepository
    }

    func onAppear() async {
        do {
            async let userDetail = try await userRepository.fetch(userID: userID)
            async let repositories = try await repoRepository.fetch(userID: userID)

            self.userDetail = try await userDetail
            self.repositories = try await repositories
        } catch {
            // TODO
        }
    }

    func onRepositoryTapped(repository: Repository) {
        presentingRepository = repository
    }
}
