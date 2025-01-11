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
    let urlString: String
}

extension Repository {
    static func make() -> Repository {
        .init(
            id: UUID().uuidString,
            name: "Alamofire",
            language: "Swiift",
            starCount: 12345,
            description: "Alamofire is an HTTP networking library written in Swift.",
            urlString: "https://github.com/Alamofire/Alamofire"
        )
    }
}
