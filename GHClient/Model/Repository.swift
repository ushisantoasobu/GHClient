//
//  Repository.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/11.
//

import Foundation

struct Repository: Identifiable {
    let id: Int
    let name: String
    let language: String?
    let starCount: Int
    let description: String?
    let urlString: String
    let isFolked: Bool
}

extension Repository {
    static func make() -> Repository {
        .init(
            id: Int.random(in: 0...1_000_000),
            name: "Alamofire",
            language: "Swiift",
            starCount: 12345,
            description: "Alamofire is an HTTP networking library written in Swift.",
            urlString: "https://github.com/Alamofire/Alamofire",
            isFolked: false
        )
    }
}
