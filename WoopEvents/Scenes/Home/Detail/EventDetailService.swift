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
    func checkin(with requestObject: EventCheckInRequestObject, completionHandler: @escaping CheckInCompletionHandler)
}

class EventDetailService {
    private var apiService: APIManagerProtocol

    // MARK: - Initialization
    init(service: APIManagerProtocol = APIManager()) {
        apiService = service
    }
}

extension EventDetailService: EventDetailServiceProtocol {
    func checkin(with requestObject: EventCheckInRequestObject, completionHandler: @escaping CheckInCompletionHandler) {
        let route = HomeDetailRoute.checkIn(requestObject)
        apiService.requestObject(with: route.config) { (result: Result<EventCheckInResponseObject, Error>) in
            let resultMapped = result.map { _ in true }
            completionHandler(resultMapped)
        }
    }
}
