//
//  UserListViewModel.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/14.
//

import SwiftUI

@MainActor
class UserListViewModel: ObservableObject {

    @Published var searchText = ""
    @Published var users: [User] = []
    @Published var isFetching = false
    @Published var hasNext = false

    private let userRepository: any UserRepository

    private var page: Int = 1

    init(userRepository: any UserRepository = UserRepoRepositoryImpl()) {
        self.userRepository = userRepository
    }

    func onSearch() {
        Task {
            await fetch(refresh: true)
        }
    }

    func onScrollToBottom() {
        guard !isFetching else { return }
        guard hasNext else { return }

        Task {
            await fetch(refresh: false)
        }
    }

    private func fetch(refresh: Bool) async {
        isFetching = true
        do {
            let response = try await userRepository.fetch(userName: searchText, page: page)
            if refresh {
                users = response.list
            } else {
                users.append(contentsOf: response.list)
            }
            hasNext = response.hasNext
            page += 1
            isFetching = false
        } catch {
            hasNext = false
            isFetching = false
            print(error)
        }
    }
}
