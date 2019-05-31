//
//  UIViewControllerTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-31.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
@testable import WoopEvents

class UIViewControllerTests: XCTestCase {
    var window: UIWindow!
    var viewController: ViewControllerTestable!

    override func setUp() {
        super.setUp()
        window = UIWindow()
        viewController = ViewControllerTestable()
    }

    private func loadView() {
        window.addSubview(viewController.view)
        RunLoop.current.run(until: Date())
    }

    override func tearDown() {
        window = nil
        super.tearDown()
    }

    func testShowAlertView() {
        // Given
        loadView()

        // When
        let title = "Titulo"
        viewController.showAlert(title: title)

        // Then
        XCTAssertTrue(viewController.presentedViewController is UIAlertController)
        XCTAssertEqual(viewController.presentedViewController?.title, "Titulo")
    }
}

class ViewControllerTestable: UIViewController {
    func presentAlert(with title: String) {
        showAlert(title: title)
    }
}
