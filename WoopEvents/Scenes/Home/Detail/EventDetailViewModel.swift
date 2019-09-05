//
//  EventDetailViewModel.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
import CoreLocation

typealias EventDetailViewModelProtocol = CheckInPresentation & EventDetailPresentation & ServiceModelControllerProtocol

struct CheckInResult {
    var status: Bool
    var title: String?
    var msg: String?

    static func status(success: Bool,
                       title: String? = nil,
                       msg: String? = nil) -> CheckInResult {
        return CheckInResult(status: success,
                             title: title,
                             msg: msg)
    }

    static func initialState() -> CheckInResult {
    	return CheckInResult(status: false, title: nil, msg: nil)
    }
}

protocol EventDetailNavigationProtocol: AnyObject {
    func didTapShare(_ objectsToShare: [Any])
}

protocol CheckInPresentation: AnyObject {
    var checkinSucessMsg: String { get }
    var checkinSucessTitle: String { get }
    var checkinErrorTitle: String { get }
    var checkInButtonTitle: String { get }
    var sharedButtonTitle: String { get }
    var detailsTitle: String { get }
  	var checkInResult: Bindable<CheckInResult> { get }

  	func checkIn()
}

protocol EventDetailPresentation: AnyObject {
    var eventTitle: String { get }
    var eventDay: String { get }
    var eventMonth: String { get }
    var eventLocation: CLLocationCoordinate2D { get }
    var eventDescription: String { get }
    var eventFullDate: String { get }
    var eventImageUrl: URL { get }

    func shareObjects(_ objectsToShare: [Any])
}

class EventDetailViewModel {
    var checkinSucessMsg = localized(by: "HomeDetailCheckInSuccessTitle")
    var checkinSucessTitle = localized(by: "HomeDetailCheckInSuccessTitle")
    var checkinErrorTitle = localized(by: "HomeDetailErrorTitle")
    var checkInButtonTitle = localized(by: "HomeDetailCheckinButtonTitle")
    var sharedButtonTitle = localized(by: "HomeDetailShareButtonTitle")
    var detailsTitle = localized(by: "HomeDetailDetailsTitle")

    var eventDay: String
    var eventTitle: String
    var eventMonth: String
    var eventFullDate: String
    var eventDescription: String
    var eventLocation: CLLocationCoordinate2D
    var eventImageUrl: URL
    var checkInResult: Bindable<CheckInResult> = Bindable(.initialState())
    var requestModel: Bindable<RequestViewModel> = Bindable(.loading(isLoading: false))

    private var service: EventDetailServiceProtocol
    private weak var navigationDelegate: EventDetailNavigationProtocol?
    private let event: Event

    init(event: Event,
         service: EventDetailServiceProtocol = EventDetailService(),
         navigationDelegate: EventDetailNavigationProtocol? = nil) {
        self.event = event
        self.service = service
        self.navigationDelegate = navigationDelegate
        eventTitle = event.title
        eventDescription = event.eventDescription
        eventImageUrl = event.image
        eventDay = DateFormatter.dayDateFormat.string(from: event.date)
        eventMonth = DateFormatter.shortMonthBrazilianDateFormat.string(from: event.date)
        eventFullDate = DateFormatter.fullDateEventDateFormat.string(from: event.date)
        eventLocation = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
    }
}

extension EventDetailViewModel: EventDetailViewModelProtocol {
    func checkIn() {
        let userEmail = "felipe@gmail.com"
        let userName = "felipe"
        let parameters = EventCheckInRequestObject(eventId: event.id, name: userName, email: userEmail)
    
        requestModel.update(with: .loading(isLoading: true))

        service.request(path: .checkIn(with: parameters)) { result in

            self.requestModel.update(with: .loading(isLoading: false))

            switch result {
            case .success:
                self.checkInResult.update(with: .status(success: true,
                                                        title: self.checkinSucessTitle,
                                                        msg: self.checkinSucessMsg))

            case .failure(let error):
                self.requestModel.update(with: .error(title: self.checkinErrorTitle,
                                                      message: error.localizedDescription))
            }
        }
    }

    func shareObjects(_ objectsToShare: [Any]) {
        navigationDelegate?.didTapShare(objectsToShare)
    }
}
