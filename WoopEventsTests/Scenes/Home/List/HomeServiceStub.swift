//
//  HomeServiceStub.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-07-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
@testable import WoopEvents

class HomeServiceStub {
    var fetchCalled = false
}

class HomeServiceSuccessStub: HomeServiceStub, HomeServiceProtocol {
    func request(path route: HomeRoute, completionHandler: @escaping FetchEventsCompletionHandler) {
        let events = Events.stub(withCount: 3)
        completionHandler(.success(events))
    }
}

class HomeServiceErrorStub: HomeServiceStub, HomeServiceProtocol {
    enum SpyErrors: Error {
        case `default`
    }

    func request(path route: HomeRoute, completionHandler: @escaping FetchEventsCompletionHandler) {
        completionHandler(.failure(SpyErrors.default))
    }
}
