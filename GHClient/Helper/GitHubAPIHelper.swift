//
//  GitHubAPIHelper.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/13.
//

import Foundation
import os

struct GitHubAPIHelper {

    static func getPAT() -> String? {
        if let pat = EnvService.shared.getGitHubPAT() {
            return pat
        } else {
            os.Logger().warning("PersonalAccessTokenが正しく設定されていません。GitHubのAPIの利用が1時間あたり60回までに制限されます")
            return nil
        }
    }
}
