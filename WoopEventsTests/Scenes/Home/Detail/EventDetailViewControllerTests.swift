//
//  EventDetailViewControllerTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-31.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
import CoreLocation
import Quick
import Nimble
@testable import WoopEvents

final class EventDetailViewControllerTests: QuickSpec {

    override func spec() {
        super.spec()
        var window: UIWindow!
        let viewModel: EventDetailViewModelStub = EventDetailViewModelStub()
        var viewController: EventDetailViewController!

        beforeEach {
            window = UIWindow(frame: UIScreen.main.bounds)
            viewController = EventDetailViewController(viewModel: viewModel)
            window.addSubview(viewController.view)
        }

        describe("tela de detalhe") {
            context("tocar no botão checkin") {
                it("deve fazer o checkin") {
                    let mirrorViewController = EventDetailViewControllerMirror(viewController: viewController)

                    mirrorViewController.checkinButton?.sendActions(for: .touchUpInside)

					expect(viewModel.checkinCalled).to(equal(true))
                }
            }

            context("tocar no botão compartilhar") {
                it("deve compartilhar os detalhes do evento") {
                    let mirrorViewController = EventDetailViewControllerMirror(viewController: viewController)

                    mirrorViewController.shareButton?.sendActions(for: .touchUpInside)

                    let result = "Titulo"
                    let title = viewModel.objectsToShareCalled.first as? String

					expect(title).to(equal(result))
                }
            }
        }
    }
}

final class EventDetailViewModelStub: EventDetailViewModelProtocol {
    var checkinSucessMsg: String = ""
    var checkinSucessTitle: String = ""
    var checkinErrorTitle: String = ""
    var checkInButtonTitle: String = ""
    var sharedButtonTitle: String = ""
    var detailsTitle: String = ""
    var eventTitle: String = "Titulo"
    var eventDay: String = "23"
    var eventMonth: String = "set"
    var eventLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 11.0, longitude: 10.0)
    var eventDescription: String = "Descrição"
    var eventFullDate: String = "23 de setembro de 1990 06:00"
    //swiftlint:disable force_unwrapping
    var eventImageUrl: URL = URL(string: "www.google.com")!
    var checkInResult: Bindable<CheckInResult> = .init(CheckInResult.status(success: true))
    var requestModel: Bindable<RequestViewModel> = .init(RequestViewModel.loading(isLoading: true))

    var checkinCalled = false
    var objectsToShareCalled: [Any] = []

    func checkIn() {
        checkinCalled = true
    }

    func shareObjects(_ objectsToShare: [Any]) {
        objectsToShareCalled = objectsToShare
    }
}
