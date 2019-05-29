//
//  XCTestCase+Extension.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest

extension XCTestCase {
    func loadJson<T: Decodable>(filename fileName: String,
                                inDirectory: String? = nil,
                                dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) -> T? {
        let bundle = Bundle.init(for: type(of: self))
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                if let dateDecodingStrategy = dateDecodingStrategy {
                    decoder.dateDecodingStrategy = dateDecodingStrategy
                }
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
