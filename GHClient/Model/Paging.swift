//
//  Paging.swift
//  GHClient
//
//  Created by Shunsuke Sato on 2025/01/13.
//

import Foundation

struct Paging<T> {
    let list: [T]
    let hasNext: Bool
}
