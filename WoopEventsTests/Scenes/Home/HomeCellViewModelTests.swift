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

        let event = Event(id: "1",
                          title: "Encontro regional ONGS",
                          price: 10.0,
                          latitude: 10.0,
                          longitude: 10.0,
                          //swiftlint:disable force_unwrapping
                          image: URL(string: "www.google.com")!,
                          eventDescription: "Encontro para discutir soluções voltadas a engajamento e captação de recursos",
                          //swiftlint:disable force_unwrapping
                          date: dateFormatter.date(from: "23/09/1990")!,
                          people: [],
                          cupons: [])
        viewModel = HomeCellViewModel(event: event)
    }

    func testParseDataToPresent() {
        XCTAssertEqual(viewModel.title, "Encontro regional ONGS")
        XCTAssertEqual(viewModel.day, "23")
        XCTAssertEqual(viewModel.month, "set")
        XCTAssertEqual(viewModel.description, "Encontro para discutir soluções voltadas a engajamento e captação de recursos")
        //swiftlint:disable force_unwrapping
        XCTAssertEqual(viewModel.imageUrl, URL(string: "www.google.com")!)
        XCTAssertEqual(viewModel.event.id, "1")
    }

    func testCancelDownloadCalled() {
        viewModel.cancelImageDownload()

        XCTAssertTrue(viewModel.imageDownloadCancellation.value)
    }
}
