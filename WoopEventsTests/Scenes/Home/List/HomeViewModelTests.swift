//
//  HomeViewModelTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
@testable import WoopEvents

final class HomeViewModelTests: XCTestCase {
    var navigation: HomeNavigationSpy!

    override func setUp() {
        super.setUp()

        navigation = HomeNavigationSpy()
    }

    func testFetchEventsSuccess() {
        // Given
        let service = HomeServiceSuccessStub()
        let viewModel = HomeViewModel(service: service)
        let observer = DynamicObserver<Bool>()
        viewModel.loading.setObserver(with: observer)

        // When
        viewModel.fetchEvents()

        // Then
        XCTAssertEqual(observer.values, [true, false])
        let events = viewModel.events
        XCTAssertNotNil(events.value.first)
    }

    func testFetchEventsFailure() {
        // Given
        let service = HomeServiceErrorStub()
        let viewModel = HomeViewModel(service: service)
        let observer = DynamicObserver<Bool>()
        viewModel.loading.setObserver(with: observer)

        // When
        viewModel.fetchEvents()

        // Then
        XCTAssertEqual(observer.values, [true, false])
        let events = viewModel.events
        XCTAssertNil(events.value.first)
        XCTAssertEqual(viewModel.eventsCount(), 0)
        XCTAssertNotNil(viewModel.error.value)
    }

    func testEventsCount() {
        // Given
        let service = HomeServiceSuccessStub()
        let viewModel = HomeViewModel(service: service)

        // When
        viewModel.fetchEvents()

        // Then
        XCTAssertEqual(viewModel.eventsCount(), 3)
    }

    func testViewModelGetObject() {
        // Given
        let service = HomeServiceSuccessStub()
        let viewModel = HomeViewModel(service: service)
        viewModel.fetchEvents()

        // When
        let object = viewModel.getObject(at: 0)

        // Then
        XCTAssertEqual(object?.event.id, "0")
    }

    func testGetImageUrls() {
        // Given
        let service = HomeServiceSuccessStub()
        let viewModel = HomeViewModel(service: service)

        viewModel.fetchEvents()

        // When
        let imageUrls = viewModel.getImagesUrls(at: [IndexPath(row: 0, section: 0)])

        // Then
        let url = URL(string: "www.google.com")
        XCTAssertEqual([url], imageUrls)
    }
}

class HomeNavigationSpy: HomeNavigationProtocol {
    var selectedEvent: Event?

    func didSelectEvent(_ event: Event) {
        selectedEvent = event
    }
}
