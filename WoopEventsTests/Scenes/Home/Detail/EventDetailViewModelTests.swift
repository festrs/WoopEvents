//
//  EventDetailViewModelTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-31.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WoopEvents

final class EventDetailViewModelTests: XCTestCase {

    func testConstructor() {
        let viewModel = EventDetailViewModel(event: Event.stub(withID: "123"))

        XCTAssertEqual(viewModel.eventDay, "23")
        XCTAssertEqual(viewModel.eventTitle, "Encontro regional ONGS")
        XCTAssertEqual(viewModel.eventMonth, "set")
        XCTAssertEqual(viewModel.eventFullDate, "23 de setembro de 1990 06:00")
        XCTAssertEqual(viewModel.eventDescription, "Encontro para discutir soluções voltadas a engajamento e captação de recursos")
        let location = CLLocationCoordinate2D(latitude: 11.0, longitude: 10.0)
        XCTAssertEqual(viewModel.eventLocation.longitude, location.longitude)
        XCTAssertEqual(viewModel.eventLocation.latitude, location.latitude)
        //swiftlint:disable force_unwrapping
        XCTAssertEqual(viewModel.eventImageUrl, URL(string: "www.google.com")!)
    }

    func testCheckinSuccess() {
        let successService = EventDetailtServiceSuccessStub()
        let event = Event.stub(withID: "123")
      	let viewModel = EventDetailViewModel(event: event, service: successService)

        viewModel.checkIn()

        XCTAssertTrue(successService.checkInCalled)
      	XCTAssertTrue(viewModel.checkInResult.lastValue?.status ?? false)
    }

    func testCheckinFailure() {
        let errorService = EventDetailtServiceErrorStub()
        let event = Event.stub(withID: "123")
      	let viewModel = EventDetailViewModel(event: event, service: errorService)

        viewModel.checkIn()

        XCTAssertTrue(errorService.checkInCalled)
        XCTAssertFalse(viewModel.checkInResult.lastValue?.status ?? true)
    }

    func testSharedShouldCallNavigation() {
        let event = Event.stub(withID: "123")
        let navigation = EventNavigationSpy()
      	let viewModel = EventDetailViewModel(event: event, navigationDelegate: navigation)

        viewModel.shareObjects([])

        XCTAssertTrue(navigation.didTapShareCalled)
    }
}

final class EventNavigationSpy: EventDetailNavigationProtocol {
    var didTapShareCalled = false

    func didTapShare(_ objectsToShare: [Any]) {
        didTapShareCalled = true
    }
}
