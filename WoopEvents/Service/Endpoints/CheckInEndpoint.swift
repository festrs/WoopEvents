//
//  CheckInEndpoint.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2020-04-09.
//  Copyright © 2020 FelipeP. All rights reserved.
//

import Foundation

extension Request {
    static func checkIn(with credentials: EventCheckInRequestObject) -> Self {
        guard let unParameters = try? credentials.asDictionary() else {
            preconditionFailure("Cannot parse CheckIn credentials :\(credentials)")
        }
        return Request(endpoint: .checkIn,
                       method: .post,
                       bodyParameters: unParameters)
    }
}

extension Endpoint {
    static var checkIn: Self {
        Endpoint(path: "/checkin")
    }
}
