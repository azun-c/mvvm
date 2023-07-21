//
//  Collection+Extensions.swift
//  mvvm
//
//  Created by azun on 21/07/2023.
//

import Foundation

extension Collection {
    public subscript(safe index: Self.Index) -> Self.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
