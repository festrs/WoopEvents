//
//  HomeDetailRoute.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

struct HomeDetailRoute: APIRoute {
    var config: RequestConfig

    private init(with config: RequestConfig) {
        self.config = config
    }
}

extension HomeDetailRoute {
    static func checkIn(with parameter: EventCheckInRequestObject) -> HomeDetailRoute {
        let parameters = try? parameter.asDictionary()
        let config = RequestConfig(path: "checkin",
                                   method: .post,
                                   encoding: .default,
                                   parameters: parameters ?? [:])

        return HomeDetailRoute(with: config)
    }
}
