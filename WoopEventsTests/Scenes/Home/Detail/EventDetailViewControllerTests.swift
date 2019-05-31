//
//  EventDetailViewControllerTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-31.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WoopEvents

class EventDetailViewControllerTests: XCTestCase {
    var window: UIWindow!
    var viewController: EventDetailViewController!
    var viewModel: EventDetailViewModelSpy!

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: UIScreen.main.bounds)
        viewModel = EventDetailViewModelSpy()
        viewController = EventDetailViewController(viewModel: viewModel)
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    private func loadView() {
        window.addSubview(viewController.view)
        RunLoop.current.run(until: Date())
    }

    func testViewDidLoadShouldBindVariables() {
        // Given
        loadView()

        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertTrue(viewModel.loading.isBinded())
        XCTAssertTrue(viewModel.error.isBinded())
        XCTAssertTrue(viewModel.checkInResult.isBinded())
    }

    func testViewDidLoadShouldUpdateUI() {
        // Given
        loadView()

        // When
        viewController.viewDidAppear(true)

        // Then
        XCTAssertEqual(viewController.eventTitleLabel.text, "Titulo")
        XCTAssertEqual(viewController.eventDayLabel.text, "23")
        XCTAssertEqual(viewController.eventTimeLabel.text, "23 de setembro de 1990 06:00")
        XCTAssertEqual(viewController.eventDescriptionLabel.text, "Descrição")
        XCTAssertEqual(viewController.eventMonthLabel.text, "set")
        XCTAssertEqual(viewController.mapView.annotations.count, 1)
    }

    func testShouldSendActionsWhenTapCheckInButton() {
        // Given
        loadView()

        // When
        viewController.checkinButton.sendActions(for: .touchUpInside)

        // Then
        XCTAssertTrue(viewModel.checkinCalled)
    }

    func testShouldShowActivityWhenTapShareButton() {
        // Given
        loadView()

        // When
        viewController.shareButton.sendActions(for: .touchUpInside)

        // Then
        XCTAssertTrue(viewModel.shareObjectsCalled)
    }
}

class EventDetailViewModelSpy: EventDetailViewModelProtocol {
    var eventTitle: String = "Titulo"
    var eventDay: String = "23"
    var eventMonth: String = "set"
    var eventLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 11.0, longitude: 10.0)
    var eventDescription: String = "Descrição"
    var eventFullDate: String = "23 de setembro de 1990 06:00"
    //swiftlint:disable force_unwrapping
    var eventImageUrl: URL = URL(string: "www.google.com")!
    var checkInResult: Dynamic<Bool> = Dynamic(false)
    var loading: Dynamic<Bool> = Dynamic(false)
    var error: Dynamic<String?> = Dynamic(nil)

    var checkinCalled = false
    var shareObjectsCalled = false

    func checkIn() {
        checkinCalled = true
    }

    func shareObjects(_ objectsToShare: [Any]) {
        shareObjectsCalled = true
    }
}
