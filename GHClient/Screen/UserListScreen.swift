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
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }

                        if viewModel.hasNext {
                            ListLoadingView()
                                .listRowSeparator(.hidden)
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
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                UserThumbnailView(urlString: user.imageURLString, size: 44)
                Text(user.name)
                    .font(.title3)
            }
            .padding()

            Divider()
        }
    }
}

#Preview {
    UserListScreen()
}
