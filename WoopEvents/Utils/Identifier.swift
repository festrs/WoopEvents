//
//  Identifier.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-08-12.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

// https://www.swiftbysundell.com/articles/type-safe-identifiers-in-swift/

protocol Identifiable {
    associatedtype RawIdentifier: Codable = String

    var id: Identifier<Self> { get }
}

struct Identifier<Value: Identifiable> {
    let rawValue: Value.RawIdentifier

    init(rawValue: Value.RawIdentifier) {
        self.rawValue = rawValue
    }
}

extension Identifier: ExpressibleByIntegerLiteral where Value.RawIdentifier == Int {
    typealias IntegerLiteralType = Int

    init(integerLiteral value: Int) {
        rawValue = value
    }
}

extension Identifier: ExpressibleByUnicodeScalarLiteral where Value.RawIdentifier == String {
    typealias UnicodeScalarLiteralType = String

    init(unicodeScalarLiteral value: String) {
        rawValue = value
    }
}

extension Identifier: ExpressibleByExtendedGraphemeClusterLiteral where Value.RawIdentifier == String {
    typealias ExtendedGraphemeClusterLiteralType = String
}

extension Identifier: ExpressibleByStringLiteral where Value.RawIdentifier == String {
    typealias StringLiteralType = String

    init(stringLiteral value: String) {
        rawValue = value
    }
}

extension Identifier: CustomStringConvertible where Value.RawIdentifier == String {
    var description: String {
        return rawValue
    }
}

extension Identifier: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(Value.RawIdentifier.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
