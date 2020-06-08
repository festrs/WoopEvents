//
//  EventDetailServiceStub.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-07-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
import Combine
@testable import WoopEvents

class EventDetailServiceStub {
    var checkInCalled = false
}

final class EventDetailtServiceSuccessStub: EventDetailServiceStub, DataRequestable {
    enum SpyError: Error {
        case `default`
    }

    @available(iOS 13.0, *)
    func request<T>(_ request: Request) -> AnyPublisher<T, Error> where T : Decodable {
        let events = Events.stub(withCount: 3)
        guard let unEvents = events as? T else {
            preconditionFailure("T is not events")
        }
        return Just(unEvents)
            .mapError { _ in
                SpyError.default
        }.eraseToAnyPublisher()
    }

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
    @available(iOS 13.0, *)
    func request<T>(_ request: Request) -> AnyPublisher<T, Error> where T : Decodable {
        let events = Events.stub(withCount: 3)
        guard let unEvents = events as? T else {
            preconditionFailure("T is not events")
        }
        return Just(unEvents)
            .mapError { _ in
                SpyError.default
        }.eraseToAnyPublisher()
    }

    func request<T>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        checkInCalled = true
        completion(.failure(SpyError.default))
    }

    enum SpyError: Error {
        case `default`
    }

}
