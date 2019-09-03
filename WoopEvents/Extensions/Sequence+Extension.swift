//
//  Sequence+Extension.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-08-08.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }

    func compactMap<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return compactMap { $0[keyPath: keyPath] }
    }

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { lhs, rhs in
            return lhs[keyPath: keyPath] < rhs[keyPath: keyPath]
        }
    }
}
