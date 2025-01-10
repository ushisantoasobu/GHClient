//
//  Repository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import Foundation

struct Repository: Identifiable {
    let id: String
    let name: String
    let language: String
    let starCount: Int
    let description: String
}
