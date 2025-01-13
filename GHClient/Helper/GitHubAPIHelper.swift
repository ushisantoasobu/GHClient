//
//  GitHubAPIHelper.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/13.
//

import Foundation

struct GitHubAPIHelper {

    // TODO: キャッシュさせるのと整理
    static func getPAT() -> String? {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            guard let str = String(data: data, encoding: .utf8) else { return nil }
            let components = str.split(separator: "=", maxSplits: 1)
            return components[1].trimmingCharacters(in: .whitespaces)
        } catch {
            return nil
        }
    }
}
