//
//  Environment.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

struct Environment {
    private static let environmentFile = Bundle.main.path(forResource: "Environment", ofType: "plist")

    static var baseUrl: String = {
        guard let environmentFile = environmentFile,
            let environmentDictionary = NSDictionary(contentsOfFile: environmentFile),
            let url = environmentDictionary["BASE_URL"] as? String
            else {
                fatalError("BASE_URL not found in Environment.plist")
        }
        return url
    }()
}
