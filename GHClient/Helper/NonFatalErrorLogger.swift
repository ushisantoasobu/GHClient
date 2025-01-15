//
//  NonFatalErrorLogger.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/16.
//

import Foundation

enum NonFatalError: LocalizedError {
    case failedToSetUpEnv
    case failedToCreateGitHubAPIURL
    case failedToShowRepositoryDetail

    var errorDescription: String? {
        "原因不明のエラーが発生しました"
    }
}

struct NonFatalErrorLogger {
    func log(error: NonFatalError) {
        print("NonFatalErrorLogger log: \(error)")
        // TODO: FirebaseのnonFatalErrorなどを利用して「起こり得ないエラー」を確認できるようにする
    }
}
