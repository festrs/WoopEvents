//
//  EventDetailViewModel.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
import CoreLocation

protocol EventDetailNavigationProtocol: AnyObject {
    func didTapShare(_ objectsToShare: [Any])
}

protocol EventDetailViewModelProtocol: RequestViewModelProtocol {
    var eventTitle: String { get }
    var eventDay: String { get }
    var eventMonth: String { get }
    var eventLocation: CLLocationCoordinate2D { get }
    var eventDescription: String { get }
    var eventFullDate: String { get }
    var eventImageUrl: URL { get }
    var checkInResult: Dynamic<Bool> { get }

    func checkIn()
    func shareObjects(_ objectsToShare: [Any])
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
    let checkInResult: Dynamic<Bool> = Dynamic(false)
    private let event: Event
    private weak var navigationDelegate: EventDetailNavigationProtocol?

    init(service: EventDetailServiceProtocol = EventDetailService(),
         navigationDelegate: EventDetailNavigationProtocol? = nil,
         event: Event) {
        self.service = service
        self.navigationDelegate = navigationDelegate
        self.event = event
        eventTitle = event.title
        eventDescription = event.eventDescription
        eventImageUrl = event.image
        eventDay = DateFormatter.dayDateFormat.string(from: event.date)
        eventMonth = DateFormatter.shortMonthBrazilianDateFormat.string(from: event.date)
        eventLocation = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        eventFullDate = dateFormatter.string(from: event.date)
    }
}

extension EventDetailViewModel: EventDetailViewModelProtocol {
    func shareObjects(_ objectsToShare: [Any]) {
        navigationDelegate?.didTapShare(objectsToShare)
    }

    func checkIn() {
        let userEmail = "felipe@gmail.com"
        let userName = "felipe"
        let requestObject = EventCheckInRequestObject(eventId: event.id, name: userName, email: userEmail)

        loading.value = true
        service.checkin(with: requestObject) { result in
            self.loading.value = false

            switch result {
            case .success:
                self.checkInResult.value = true

            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
}
