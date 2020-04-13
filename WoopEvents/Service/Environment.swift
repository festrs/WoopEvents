//
//  Environment.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

public enum Environment {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let baseUrl = "BASE_URL"
        }
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let baseUrl: URL = {
        guard let baseUrl = Environment.infoDictionary[Keys.Plist.baseUrl] as? String,
            let url = URL(string: baseUrl) else {
                fatalError("API Key not set in plist for this environment")
        }
        return url
    }()
}
