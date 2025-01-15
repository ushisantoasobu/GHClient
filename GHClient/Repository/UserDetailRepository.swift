//
//  UserDetailRepository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/15.
//

protocol UserDetailRepository {
    func fetch(userName: String) async throws -> UserDetail
}
