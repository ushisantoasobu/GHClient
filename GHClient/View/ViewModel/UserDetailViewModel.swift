//
//  UserDetailViewModel.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/14.
//

import SwiftUI


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
