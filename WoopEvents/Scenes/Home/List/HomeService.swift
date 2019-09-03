//
//  HomeService.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

typealias FetchEventsCompletionHandler = (Result<Events, Error>) -> Void

protocol HomeServiceProtocol: AnyObject {
    func request(path route: HomeRoute, completionHandler: @escaping FetchEventsCompletionHandler)
}

class HomeService {
    private var service: APIManagerProtocol
    private let cache = Cache<String, [Event]>()
    private let cacheId = "events.cache.id"

    // MARK: - Initialization
    init(service: APIManagerProtocol = APIManager()) {
        self.service = service
    }
}

extension HomeService: HomeServiceProtocol {
    func request(path route: HomeRoute, completionHandler: @escaping FetchEventsCompletionHandler) {
        if let cachedObjects = cache[cacheId] {
            return completionHandler(.success(cachedObjects))
        }

        service.requestObject(with: route.config) { (result: Result<[FailableDecodable<Event>], Error>) in
            switch result {
            case .success(let data):
                let objects = data.compactMap { $0.base }
                self.cache.insert(objects, forKey: self.cacheId)
                completionHandler(.success(objects))

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
