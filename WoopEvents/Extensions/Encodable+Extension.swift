//
//  Encodable+Extension.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary(encodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate) throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = encodingStrategy
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
