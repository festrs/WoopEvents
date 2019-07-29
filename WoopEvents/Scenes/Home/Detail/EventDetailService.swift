//
//  EventDetailService.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

typealias CheckInCompletionHandler = (Result<Bool, Error>) -> Void

protocol EventDetailServiceProtocol: AnyObject {
    func request(path route: HomeDetailRoute, completionHandler: @escaping CheckInCompletionHandler)
}

class EventDetailService {
    private var service: APIManagerProtocol

    // MARK: - Initialization
    init(service: APIManagerProtocol = APIManager()) {
        self.service = service
    }
}

extension EventDetailService: EventDetailServiceProtocol {
    func request(path route: HomeDetailRoute, completionHandler: @escaping CheckInCompletionHandler) {
        service.request(with: route.config, completion: completionHandler)
    }
}
