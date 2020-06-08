//
//  HomeServiceStub.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-07-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
import Combine
import Networking
@testable import WoopEvents

class HomeServiceStub {
    var fetchCalled = false
}

class HomeServiceSuccessStub: HomeServiceStub, DataRequestable {
    enum SpyErrors: Error {
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
                SpyErrors.default
        }.eraseToAnyPublisher()
    }

    func request<T>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
		fetchCalled = true
        let events = Events.stub(withCount: 3)
        guard let unEvents = events as? T else {
            preconditionFailure("T is not events")
        }
        completion(.success(unEvents))
    }
}

class HomeServiceErrorStub: HomeServiceStub, DataRequestable {
    @available(iOS 13.0, *)
    func request<T>(_ request: Request) -> AnyPublisher<T, Error> where T : Decodable {
        let events = Events.stub(withCount: 3)
        guard let unEvents = events as? T else {
            preconditionFailure("T is not events")
        }
        return Just(unEvents)
            .mapError { _ in
                SpyErrors.default
        }.eraseToAnyPublisher()
    }

    func request<T>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        fetchCalled = true
        completion(.failure(SpyErrors.default))
    }

    enum SpyErrors: Error {
        case `default`
    }
}
