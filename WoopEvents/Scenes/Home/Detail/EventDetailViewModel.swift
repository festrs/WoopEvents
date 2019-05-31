//
//  EventDetailViewModel.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
import CoreLocation

protocol EventDetailViewModelProtocol: RequestViewModelProtocol {
    var eventTitle: String { get }
    var eventDay: String { get }
    var eventMonth: String { get }
    var eventLocation: CLLocationCoordinate2D { get }
    var eventDescription: String { get }
    var eventFullDate: String { get }
    var eventImageUrl: URL { get }

    func checkIn()
}

class EventDetailViewModel {
    private var service: EventDetailServiceProtocol
    let eventDay: String
    let eventTitle: String
    let eventMonth: String
    let eventFullDate: String
    let eventDescription: String
    let eventLocation: CLLocationCoordinate2D
    let eventImageUrl: URL
    let loading: Dynamic<Bool> = Dynamic(false)
    let error: Dynamic<String?> = Dynamic(nil)
    private let event: Event

    init(service: EventDetailServiceProtocol = EventDetailService(), event: Event) {
        self.service = service
        self.event = event
        eventTitle = event.title
        eventDescription = event.eventDescription
        eventImageUrl = event.image
        eventDay = DateFormatter.dayDateFormat.string(from: event.date)
        eventMonth = DateFormatter.shortMonthBrazilianDateFormat.string(from: event.date)
        eventLocation = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        eventFullDate = dateFormatter.string(from: event.date)
    }
}

extension EventDetailViewModel: EventDetailViewModelProtocol {
    func checkIn() {
        let userEmail = "felipe@gmail.com"
        let userName = "felipe"
        let requestObject = EventCheckInRequestObject(eventId: event.id, name: userName, email: userEmail)

        loading.value = true
        service.checkin(with: requestObject) { result in
            self.loading.value = false

            switch result {
            case .success:
                print("yeah")

            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
