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
                } else if viewModel.noData && !viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 48, height: 48)

                        Text(String(localized: "UserListScreen.Text.NoData \(viewModel.searchText)"))
                    }
                    .foregroundStyle(.gray)
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
                                .id(UUID()) // ref: https://stackoverflow.com/a/75431883
                                .listRowSeparator(.hidden)
                                .onAppear {
                                    viewModel.onScrollToBottom()
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            // navigation
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ScreenPath.self) { path in
                switch path {
                case .userDetail(let userName):
                    UserDetailScreen(userName: userName)
                }
            }
        }
        .searchable(text: $viewModel.searchText, isPresented: $viewModel.isSearchFocusing)
        .onSubmit(of: .search) {
            viewModel.onSearch()
        }
        // error alert
        .alert("Common.Error.Title", isPresented: .constant(viewModel.fetchError != nil)) {
            Button("Common.OK") {
                viewModel.fetchError = nil
            }
        } message: {
            Text(viewModel.fetchError?.localizedDescription ?? "Error.Message.Unknown")
        }
    }
}

private struct UserListView: View {

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
