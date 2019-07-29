//
//  HomeViewControllerTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
@testable import WoopEvents

final class HomeTableViewControllerTests: XCTestCase {
    var window: UIWindow!
    var viewController: HomeTableViewController!
    var viewModel: HomeViewModelMock!

    override func setUp() {
        super.setUp()
        window = UIWindow()
        viewModel = HomeViewModelMock()
        viewController = HomeTableViewController(viewModel: viewModel)
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    private func loadView() {
        window.addSubview(viewController.view)
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
        let event = Event.stub(withID: "1")
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

    func testShouldConfigureTableViewCellToDisplayEvent() {
        // Given
        let tableView = viewController.tableView
        viewController.viewDidLoad()

        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = viewController.tableView(tableView!, cellForRowAt: indexPath) as? HomeTableViewCell
        viewController.tableView(tableView!, willDisplay: cell!, forRowAt: indexPath)

        // Then
        let cellMirror = HomeTableViewCellMirror(tableViewCell: cell ?? UITableViewCell())
        XCTAssertEqual(cellMirror.eventTitleLabel?.text, "Encontro regional ONGS")
        XCTAssertEqual(cellMirror.eventDayLabel?.text, "23")
        XCTAssertEqual(cellMirror.eventMonthLabel?.text, "set")
        let description = "Encontro para discutir soluções voltadas a engajamento e captação de recursos"
        XCTAssertEqual(cellMirror.eventDescriptionLabel?.text, description)
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

class HomeViewModelMock: HomeViewModelProtocol {
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

    func getObject(at row: Int) -> HomeCellViewModelProtocol? {
      let event = Event.stub(withID: "1")
      if shouldError {
        return nil
      } else {
        return HomeCellViewModel(event: event)
      }
    }

    func didTapCell(at indexPath: IndexPath) {
        didTapCellCalled = true
    }
}
