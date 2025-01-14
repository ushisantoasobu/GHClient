//
//  UserListScreen.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import SwiftUI

enum ScreenPath: Hashable {
    case userDetail(userName: String)
}

struct UserListScreen: View {

    @State private var screenPath: [ScreenPath] = []

    @ObservedObject private var viewModel = UserListViewModel()

    var body: some View {
        NavigationStack(path: $screenPath) {
            Group {
                if viewModel.users.isEmpty && viewModel.isFetching {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            Button {
                                screenPath.append(.userDetail(userName: user.name))
                            } label: {
                                UserListView(user: user)
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
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("ユーザ一覧")
            .navigationDestination(for: ScreenPath.self) { path in
                switch path {
                case .userDetail(let userName):
                    UserDetailScreen(userName: userName)
                }
            }
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
        HStack {
            UserThumbnailView(urlString: user.imageURLString, size: 44)
            Text(user.name)
        }
    }
}

#Preview {
    // memo: https://stackoverflow.com/questions/56613157/enable-keyboard-in-xcode-preview
    UserListScreen()
}

// TODO: 別ファイル化
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
