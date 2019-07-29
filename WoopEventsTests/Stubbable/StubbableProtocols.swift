//
//  StubbableProtocols.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-07-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

protocol Stubbable {
    static func stub(withID id: String) -> Self
}

extension Stubbable {
    func setting<T>(_ keyPath: WritableKeyPath<Self, T>,
                    to value: T) -> Self {
        var stub = self
        stub[keyPath: keyPath] = value
        return stub
    }
}

extension Array where Element: Stubbable {
    static func stub(withCount count: Int) -> Array {
        return (0..<count).map {
            .stub(withID: "\($0)")
        }
    }
}

extension MutableCollection where Element: Stubbable {
    func setting<T>(_ keyPath: WritableKeyPath<Element, T>,
                    to value: T) -> Self {
        var collection = self

        for index in collection.indices {
            let element = collection[index]
            collection[index] = element.setting(keyPath, to: value)
        }

        return collection
    }
}
