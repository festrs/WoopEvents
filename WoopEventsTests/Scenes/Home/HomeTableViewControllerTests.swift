//
//  HomeViewControllerTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
@testable import WoopEvents

class HomeTableViewControllerTests: XCTestCase {
    var window: UIWindow!
    var viewController: HomeTableViewController!
    var viewModel: HomeViewModelSpy!

    override func setUp() {
        super.setUp()
        window = UIWindow()
        viewModel = HomeViewModelSpy()
        viewController = HomeTableViewController(viewModel: viewModel)
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    private func loadView() {
        window.addSubview(viewController.view)
        RunLoop.current.run(until: Date())
    }

    func testShouldBindNecessaryVariables() {
        // Given
        loadView()

        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertTrue(viewModel.error.isBinded())
        XCTAssertTrue(viewModel.loading.isBinded())
        XCTAssertTrue(viewModel.events.isBinded())
    }

    func testShouldFetchEventsWhenViewDidAppear() {
        // Given
        loadView()

        // When
        viewController.viewDidAppear(true)

        // Then
        XCTAssertTrue(viewModel.fetchEventsCalled)
    }

    func testNumberOfRowsInAnySectionShouldBeEqualToNumberOfEventsToDisplay() {
        // Given
        let tableView = viewController.tableView
        viewController.viewDidLoad()

        // When
        //swiftlint:disable force_unwrapping
        let numberOfRows = viewController.tableView(tableView!, numberOfRowsInSection: 0)

        XCTAssertEqual(numberOfRows, viewModel.eventsCount())
    }

    func testNumberOfSectionsInTableViewShouldAlwaysBeOne() {
        // Given
        let tableView = viewController.tableView

        // When
        let numberOfSections = viewController.numberOfSections(in: tableView!)

        // Then
        XCTAssertEqual(numberOfSections, 1)
    }

    func testShouldDisplayFetchedOrders() {
        // Given
        let tableViewSpy = TableViewSpy()
        viewController.tableView = tableViewSpy
        viewController.viewDidLoad()

        // When
        let event = Event(id: "1",
                          title: "Encontro regional ONGS",
                          price: 10.0,
                          latitude: 10.0,
                          longitude: 10.0,
                          image: URL(string: "www.google.com")!,
                          eventDescription: "Encontro para discutir soluções voltadas a engajamento e captação de recursos",
                          date: Date(),
                          people: [],
                          cupons: [])
        viewModel.events.value = [HomeCellViewModel(event: event)]

        // Then
        XCTAssert(tableViewSpy.reloadDataCalled)
    }

    func testShouldSelectEventWhenTapTableViewCell() {
        // Given
        viewController.viewDidLoad()
        let tableView = viewController.tableView!

        // When
        viewController.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        // Then
        XCTAssertTrue(viewModel.didTapCellCalled)
    }

    func testShouldShowErrorLabelWhenFailure() {
        // Given
        viewModel.shouldError = true

        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertFalse(viewController.errorLabel.isHidden)
        XCTAssertEqual(viewController.errorLabel.text, viewModel.error.value)
    }
}

class TableViewSpy: UITableView {
    var reloadDataCalled = false

    override func reloadData() {
        reloadDataCalled = true
    }
}

class HomeViewModelSpy: HomeViewModelProtocol {
    var title: String = "Eventos"
    var loading: Dynamic<Bool> = Dynamic(false)
    var error: Dynamic<String?> = Dynamic(nil)
    var events: Dynamic<[HomeCellViewModelProtocol]> = Dynamic([])
    var fetchEventsCalled = false
    //swiftlint:disable force_unwrapping
    private let fakeUrl = URL(string: "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png")!
    var shouldError = false
    var didTapCellCalled = false

    func getImagesUrls(at indexPaths: [IndexPath]) -> [URL] {
        return [fakeUrl]
    }

    func eventsCount() -> Int {
        return 1
    }

    func fetchEvents() {
        fetchEventsCalled = true
        if shouldError {
            error.value = "generic error"
        }
    }

    func didTapCell(at indexPath: IndexPath) {
        didTapCellCalled = true
    }

    subscript(row: Int) -> HomeCellViewModelProtocol? {
        let event = Event(id: "1",
                          title: "Encontro regional ONGS",
                          price: 10.0,
                          latitude: 10.0,
                          longitude: 10.0,
                          image: fakeUrl,
                          eventDescription: "Encontro para discutir soluções voltadas a engajamento e captação de recursos",
                          date: Date(),
                          people: [],
                          cupons: [])
        if shouldError {
            return HomeCellViewModel(event: event)
        } else {
            return nil
        }
    }
}
