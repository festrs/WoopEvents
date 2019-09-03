//
//  HomeRoute.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

protocol APIRoute {
  var config: RequestConfig { get }
}

enum HomeRoute: APIRoute {
    case fetchEvents

    var config: RequestConfig {
        switch self {
        case .fetchEvents:
            let config = RequestConfig(path: "events",
                                       method: .get,
                                       encoding: .url,
                                       dateDecodeStrategy: .millisecondsSince1970)
            return config
        }
    }
}
