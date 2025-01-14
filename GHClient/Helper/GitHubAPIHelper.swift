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
        if let pat = EnvService.shared.getGitHubPAT() {
            print("PAT is correctly set")
            return pat
        } else {
            print("PAT is not set")
            return nil
        }
    }
}
