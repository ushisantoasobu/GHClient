//
//  UserRepository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import Foundation

protocol UserRepository {
    func fetch(userName: String, page: Int) async throws -> Paging<User>
}
