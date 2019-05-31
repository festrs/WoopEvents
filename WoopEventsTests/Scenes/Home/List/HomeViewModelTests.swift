//
//  HomeViewModelTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
@testable import WoopEvents

class HomeViewModelTests: XCTestCase {
    var service: HomeServiceSpy!
    var navigation: HomeNavigationSpy!
    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        if let events: Events = loadJson(filename: "events") {
            service = HomeServiceSpy(events: events)
            navigation = HomeNavigationSpy()
            viewModel = HomeViewModel(service: service, navigationDelegate: navigation)
        }
    }

    func testFetchEventsSuccess() {
        // Given
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
        let observer = DynamicObserver<Bool>()
        viewModel.loading.setObserver(with: observer)

        service.shouldFail = true

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
        // When
        viewModel.fetchEvents()

        // Then
        XCTAssertEqual(viewModel.eventsCount(), 1)
    }

    func testViewModelSubscript() {
        // Given
        viewModel.fetchEvents()

        // When
        let object = viewModel[0]?.event

        // Then
        XCTAssertEqual(object?.id, service.events.first?.id)
    }

    func testGetImageUrls() {
        // Given
        viewModel.fetchEvents()

        // When
        let imageUrls = viewModel.getImagesUrls(at: [IndexPath(row: 0, section: 0)])

        // Then
        let url = URL(string: "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png")
        XCTAssertEqual([url], imageUrls)
    }
}

class HomeServiceSpy: HomeServiceProtocol {
    var fetchCalled = false
    var shouldFail = false
    private(set) var events: Events

    enum SpyErrors: Error {
        case `default`
    }

    init(events: Events) {
        self.events = events
    }

    func fetchEvents(completionHandler: @escaping FetchEventsCompletionHandler) {
        fetchCalled = true
        if shouldFail {
            completionHandler(.failure(SpyErrors.default))
        } else {
            completionHandler(.success(events))
        }
    }
}

class HomeNavigationSpy: HomeNavigationProtocol {
    var selectedEvent: Event?

    func didSelectEvent(_ event: Event) {
        selectedEvent = event
    }
}
