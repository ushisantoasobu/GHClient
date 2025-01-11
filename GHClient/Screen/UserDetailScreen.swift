//
//  UserDetailScreen.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import SwiftUI

struct UserDetailScreen: View {

    init(userID: String) {
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

                        Text(userDetail.fullName)

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
                    //
                } label: {
                    UserDetailRepositoryView(repository: repository)
                }
            }
        }
        .listStyle(.plain)
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
    UserDetailScreen(userID: "hoge")
}

class UserDetailViewModel: ObservableObject {

    @Published var userDetail: UserDetail?
    @Published var repositories: [Repository] = []

    private let userID: String
    private let userRepository: any UserRepository
    private let repoRepository: any RepoRepository

    init(
        userID: String,
        userRepository: any UserRepository = MockUserRepository(),
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
}
