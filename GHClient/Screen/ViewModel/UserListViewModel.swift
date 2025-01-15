//
//  UserListViewModel.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/14.
//

import SwiftUI
import Combine

@MainActor
class UserListViewModel: ObservableObject {

    @Published var isSearchFocusing = true
    @Published var searchText = ""
    @Published var users: [User] = []
    @Published var isFetching = false
    @Published var hasNext = false
    @Published var noData = false
    @Published var fetchError: Error?

    private let userRepository: any UserRepository

    private var page: Int = 1

    private var cancellables = Set<AnyCancellable>()

    init(userRepository: any UserRepository = UserRepositoryImpl()) {
        self.userRepository = userRepository

        $searchText
            .sink { [weak self] _ in
                self?.noData = false
            }
            .store(in: &cancellables)
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

        if refresh {
            page = 1
            noData = false
        }

        do {
            let response = try await userRepository.fetch(userName: searchText, page: page)
            if refresh {
                users = response.list
                if users.isEmpty {
                    noData = true
                }
            } else {
                users.append(contentsOf: response.list)
            }
            hasNext = response.hasNext
            page += 1
            isFetching = false
        } catch {
            hasNext = false
            isFetching = false
            fetchError = error
        }
    }
}
