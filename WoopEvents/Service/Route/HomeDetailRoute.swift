//
//  HomeDetailRoute.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

enum HomeDetailRoute: APIRoute {
    case checkIn(EventCheckInRequestObject)

    var config: RequestConfig {
        switch self {
        case .checkIn(let object):
            let parameters = try? object.asDictionary()
            let config = RequestConfig(path: "checkin",
                                       method: .post,
                                       encoding: .default,
                                       parameters: parameters ?? [:])
            return config
        }
    }
}
