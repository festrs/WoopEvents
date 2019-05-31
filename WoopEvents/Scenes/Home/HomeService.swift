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
    func fetchEvents(completionHandler: @escaping FetchEventsCompletionHandler)
}

class HomeService {
    private var apiService: APIManagerProtocol

    // MARK: - Initialization
    init(service: APIManagerProtocol = APIManager()) {
        apiService = service
    }
}

extension HomeService: HomeServiceProtocol {
    func fetchEvents(completionHandler: @escaping FetchEventsCompletionHandler) {
        let route = HomeRoute.fetchEvents

        apiService.getObjectArrayFailable(with: route.config) { (result: Result<Events, Error>) in
            completionHandler(result)
        }
    }
}
