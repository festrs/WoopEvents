//
//  EventsEndpoint.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2020-04-09.
//  Copyright © 2020 FelipeP. All rights reserved.
//

import Foundation
import Networking

extension Request {
    static var eventList: Self  {
        Request(endpoint: Endpoint.eventList,
                dateDecodeStrategy: .millisecondsSince1970)
    }
}

extension Endpoint {
    static var eventList: Self {
        Endpoint(path: "/events")
    }
}
