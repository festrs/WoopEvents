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

final class EventDetailtServiceSuccessStub: EventDetailServiceStub, DataRequestable {
    func request<T>(_ request: Request,
                    completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let response = EventCheckInResponseObject.stub(withID:"123")

        guard let unResponse = response as? T else {
            preconditionFailure("T is not events")
        }
        checkInCalled = true
        completion(.success(unResponse))
    }
}

final class EventDetailtServiceErrorStub: EventDetailServiceStub, DataRequestable {
    func request<T>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        checkInCalled = true
        completion(.failure(SpyError.default))
    }

    enum SpyError: Error {
        case `default`
    }

}
