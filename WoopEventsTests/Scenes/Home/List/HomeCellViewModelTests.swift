//
//  HomeCellViewModelTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
@testable import WoopEvents

class HomeCellViewModelTests: XCTestCase {
    var viewModel: HomeCellViewModel!

    override func setUp() {
        super.setUp()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        let event = Event.stub(withID: "123")
        viewModel = HomeCellViewModel(event: event)
    }

    func testParseDataToPresent() {
        XCTAssertEqual(viewModel.title, "Encontro regional ONGS")
        XCTAssertEqual(viewModel.day, "23")
        XCTAssertEqual(viewModel.month, "set")
        XCTAssertEqual(viewModel.description, "Encontro para discutir soluções voltadas a engajamento e captação de recursos")
        //swiftlint:disable force_unwrapping
        XCTAssertEqual(viewModel.imageUrl, URL(string: "www.google.com")!)
        XCTAssertEqual(viewModel.event.id, "123")
    }

    func testCancelDownloadCalled() {
        viewModel.cancelImageDownload()

        XCTAssertTrue(viewModel.imageDownloadCancellation.value)
    }
}
