//
//  UserThumbnailView.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/14.
//

import SwiftUI

struct UserThumbnailView: View {

    let urlString: String
    let size: CGFloat

    var body: some View {
        if let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } placeholder: {
                Color.gray
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }
        } else {
            Color.gray
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

#Preview {
    UserThumbnailView(urlString: "", size: 44)
}
