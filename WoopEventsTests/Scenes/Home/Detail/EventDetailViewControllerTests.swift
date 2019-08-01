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

final class EventDetailViewControllerTests: XCTestCase {
    var window: UIWindow!
    var viewModel: EventDetailViewModelStub = EventDetailViewModelStub()

    override func setUp() {
        super.setUp()
        window = UIWindow(frame: UIScreen.main.bounds)
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    private func loadView(viewController: UIViewController) {
        window.addSubview(viewController.view)
        RunLoop.current.run(until: Date())
    }

    func testViewDidLoadShouldBindVariables() {
        // Given
        let viewController = EventDetailViewController(viewModel: viewModel)
        loadView(viewController: viewController)

        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertTrue(viewModel.loading.isBinded())
        XCTAssertTrue(viewModel.error.isBinded())
        XCTAssertTrue(viewModel.checkInResult.isBinded())
    }

    func testViewDidLoadShouldUpdateUI() {
        // Given
        let eventViewController = EventDetailViewController(viewModel: viewModel)
        loadView(viewController: eventViewController)

        // When
        eventViewController.viewDidAppear(true)

        // Then
        let viewController = EventDetailViewControllerMirror(viewController: eventViewController)
        XCTAssertEqual(viewController.eventTitleLabel?.text, "Titulo")
        XCTAssertEqual(viewController.eventDayLabel?.text, "23")
        XCTAssertEqual(viewController.eventTimeLabel?.text, "23 de setembro de 1990 06:00")
        XCTAssertEqual(viewController.eventDescriptionLabel?.text, "Descrição")
        XCTAssertEqual(viewController.eventMonthLabel?.text, "set")
        XCTAssertEqual(viewController.mapView?.annotations.count, 1)
    }

    func testShouldSendActionsWhenTapCheckInButton() {
        // Given
        let eventViewController = EventDetailViewController(viewModel: viewModel)
        loadView(viewController: eventViewController)

        // When
        let viewController = EventDetailViewControllerMirror(viewController: eventViewController)
        viewController.checkinButton?.sendActions(for: .touchUpInside)

        // Then
        XCTAssertTrue(viewModel.checkinCalled)
    }

    func testShouldShowActivityWhenTapShareButton() {
        // Given
        let eventViewController = EventDetailViewController(viewModel: viewModel)
        loadView(viewController: eventViewController)

        // When
        let viewController = EventDetailViewControllerMirror(viewController: eventViewController)
        viewController.shareButton?.sendActions(for: .touchUpInside)

        // Then
        XCTAssertTrue(viewModel.shareObjectsCalled)
    }
}

final class EventDetailViewModelStub: EventDetailViewModelProtocol {
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
