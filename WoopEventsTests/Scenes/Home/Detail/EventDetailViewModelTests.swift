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

class EventDetailViewModelTests: XCTestCase {
    var viewModel: EventDetailViewModel!
    var service: EventDetailtServiceSpy!
    var navigation: EventNavigationSpy!

    override func setUp() {
        super.setUp()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        let event = Event(id: "1",
                          title: "Encontro regional ONGS",
                          price: 10.0,
                          latitude: 11.0,
                          longitude: 10.0,
                          //swiftlint:disable force_unwrapping
            image: URL(string: "www.google.com")!,
            eventDescription: "Encontro para discutir soluções voltadas a engajamento e captação de recursos",
            //swiftlint:disable force_unwrapping
            date: dateFormatter.date(from: "23/09/1990 06:00")!,
            people: [],
            cupons: [])

        navigation = EventNavigationSpy()
        service = EventDetailtServiceSpy()
        viewModel = EventDetailViewModel(service: service, navigationDelegate: navigation, event: event)
    }

    func testConstructor() {
        XCTAssertEqual(viewModel.eventDay, "23")
        XCTAssertEqual(viewModel.eventTitle, "Encontro regional ONGS")
        XCTAssertEqual(viewModel.eventMonth, "set")
        XCTAssertEqual(viewModel.eventFullDate, "23 de setembro de 1990 06:00")
        XCTAssertEqual(viewModel.eventDescription, "Encontro para discutir soluções voltadas a engajamento e captação de recursos")
        let location = CLLocationCoordinate2D(latitude: 11.0, longitude: 10.0)
        XCTAssertEqual(viewModel.eventLocation.longitude, location.longitude)
        XCTAssertEqual(viewModel.eventLocation.latitude, location.latitude)
        XCTAssertEqual(viewModel.eventImageUrl, URL(string: "www.google.com")!)
        XCTAssertNil(viewModel.error.value)
        XCTAssertFalse(viewModel.loading.value)
        XCTAssertFalse(viewModel.checkInResult.value)
    }

    func testCheckinSuccess() {
        // Given
        let observer = DynamicObserver<Bool>()
        viewModel.loading.setObserver(with: observer)

        // When
        viewModel.checkIn()

        // Then
        XCTAssertTrue(service.checkInCalled)
        XCTAssertEqual(observer.values, [true, false])
        XCTAssertTrue(viewModel.checkInResult.value)
        XCTAssertNil(viewModel.error.value)
    }

    func testCheckinFailure() {
        // Given
        let observer = DynamicObserver<Bool>()
        viewModel.loading.setObserver(with: observer)

        service.shouldFail = true

        // When
        viewModel.checkIn()

        // Then
        XCTAssertTrue(service.checkInCalled)
        XCTAssertEqual(observer.values, [true, false])
        XCTAssertFalse(viewModel.checkInResult.value)
        XCTAssertNotNil(viewModel.error.value)
    }

    func testTapSharedShouldCallNavigation() {
        // Given
        // setUp()

        // When
        viewModel.shareObjects([])

        // Then
        XCTAssertTrue(navigation.didTapShareCalled)
    }
}

class EventDetailtServiceSpy: EventDetailServiceProtocol {
    var checkInCalled = false
    var shouldFail = false

    enum SpyError: Error {
        case `default`
    }

    func checkin(with requestObject: EventCheckInRequestObject, completionHandler: @escaping CheckInCompletionHandler) {
        checkInCalled = true
        if shouldFail {
            completionHandler(.failure(SpyError.default))
        } else {
            completionHandler(.success(true))
        }
    }
}

class EventNavigationSpy: EventDetailNavigationProtocol {
    var didTapShareCalled = false

    func didTapShare(_ objectsToShare: [Any]) {
        didTapShareCalled = true
    }
}
