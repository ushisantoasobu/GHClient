//
//  SafariViewRepresentable.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/12.
//

import SwiftUI
import SafariServices

struct SafariViewRepresentable: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
