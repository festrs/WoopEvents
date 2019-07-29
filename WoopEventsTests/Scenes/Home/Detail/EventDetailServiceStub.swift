//
//  EventDetailServiceStub.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-07-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
@testable import WoopEvents

class EventDetailServiceStub {
    var checkInCalled = false
}

final class EventDetailtServiceSuccessStub: EventDetailServiceStub, EventDetailServiceProtocol {

    func request(path route: HomeDetailRoute, completionHandler: @escaping CheckInCompletionHandler) {
        checkInCalled = true
        completionHandler(.success(true))
    }
}

final class EventDetailtServiceErrorStub: EventDetailServiceStub, EventDetailServiceProtocol {
    enum SpyError: Error {
        case `default`
    }

    func request(path route: HomeDetailRoute, completionHandler: @escaping CheckInCompletionHandler) {
        checkInCalled = true
        completionHandler(.failure(SpyError.default))
    }
}
