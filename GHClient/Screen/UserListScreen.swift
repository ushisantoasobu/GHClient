//
//  UserListScreen.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import SwiftUI

struct UserListScreen: View {

    @ObservedObject private var viewModel = UserListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isFetching {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            Button {
                                
                            } label: {
                                UserListView(user: user)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("ユーザ一覧")
        }
        .searchable(text: $viewModel.searchText)
        .onSubmit(of: .search) {
            viewModel.onSearch()
        }
    }
}

struct UserListView: View {

    let user: User

    var body: some View {
        Text(user.name)
    }
}

#Preview {
    // memo: https://stackoverflow.com/questions/56613157/enable-keyboard-in-xcode-preview
    UserListScreen()
}

@MainActor
class UserListViewModel: ObservableObject {

    @Published var searchText = ""
    @Published var users: [User] = []
    @Published var isFetching = false

    private let userRepository: any UserRepository

    init(userRepository: any UserRepository = MockUserRepository()) {
        self.userRepository = userRepository
    }

    func onSearch() {
        Task {
            isFetching = true
            do {
                users = try await userRepository.fetch(userName: searchText)
                isFetching = false
            } catch {
                isFetching = false
            }
        }
    }
}
