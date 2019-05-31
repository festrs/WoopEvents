//
//  EventDetailViewController.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {
    struct Constants {
        static let checkinSucessMsg = String.localized(by: "HomeDetailCheckInSuccessTitle")
        static let checkinSucessTitle = String.localized(by: "HomeDetailCheckInSuccessTitle")
        static let checkinErrorTitle = String.localized(by: "HomeDetailErrorTitle")
        static let checkInButtonTitle = String.localized(by: "HomeDetailCheckinButtonTitle")
        static let sharedButtonTitle = String.localized(by: "HomeDetailShareButtonTitle")
        static let detailsTitle = String.localized(by: "HomeDetailDetailsTitle")
    }

    let viewModel: EventDetailViewModelProtocol
    @IBOutlet private(set) weak var mapView: MKMapView!
    @IBOutlet private(set) weak var eventImageView: UIImageView!
    @IBOutlet private(set) weak var eventTitleLabel: UILabel!
    @IBOutlet private(set) weak var eventDayLabel: UILabel!
    @IBOutlet private(set) weak var eventMonthLabel: UILabel!
    @IBOutlet private(set) weak var eventDescriptionLabel: UILabel!
    @IBOutlet private(set) weak var eventTimeLabel: UILabel!
    @IBOutlet private(set) weak var shareButtonTitleLabel: UILabel! {
        didSet {
            shareButtonTitleLabel.text = Constants.sharedButtonTitle
        }
    }
    @IBOutlet private(set) weak var checkinButtonTitleLabel: UILabel! {
        didSet {
            checkinButtonTitleLabel.text = Constants.checkInButtonTitle
        }
    }
    @IBOutlet private(set) weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.text = Constants.detailsTitle
        }
    }
    @IBOutlet private(set) weak var checkinButton: UIButton!
    @IBOutlet private(set) weak var shareButton: UIButton!
    @IBOutlet private(set) weak var loaderView: UIView!
    @IBOutlet private(set) weak var loaderActivityIndicator: UIActivityIndicatorView!

    // MARK: - Life Cycle
    init(viewModel: EventDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "EventDetailViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configBind()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        loaderView.layer.cornerRadius = 4.0
        loaderView.clipsToBounds = true
    }

    // MARK: Functions
    private func configBind() {
        eventImageView.kf.setImage(with: viewModel.eventImageUrl)
        eventTitleLabel.text = viewModel.eventTitle
        eventDayLabel.text = viewModel.eventDay
        eventMonthLabel.text = viewModel.eventMonth
        eventDescriptionLabel.text = viewModel.eventDescription
        eventTimeLabel.text = viewModel.eventFullDate

        configMap()

        viewModel.checkInResult.bind { [weak self] _ in
            guard let self = self else { return }
            self.presentAlert(with: Constants.checkinSucessTitle, and: Constants.checkinSucessMsg)
        }

        viewModel.error.bind { [weak self] errorMsg in
            guard let self = self,
                let errorMsg = errorMsg else { return }
            self.presentAlert(with: Constants.checkinErrorTitle, and: errorMsg)
        }

        viewModel.loading.bind { [weak self] isLoading in
            guard let self = self else { return }
            isLoading ? self.showLoader() : self.hideLoader()
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }
    }

    private func configMap() {
        let eventLocation = MKPointAnnotation()
        eventLocation.coordinate = viewModel.eventLocation
        mapView.addAnnotation(eventLocation)

        centerMapOnLocation(viewModel.eventLocation, mapView: mapView)
    }

    private func centerMapOnLocation(_ location: CLLocationCoordinate2D, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius * 2.0,
                                                  longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    private func showLoader() {
        loaderView.isHidden = false
        loaderActivityIndicator.startAnimating()
    }

    private func hideLoader() {
        loaderView.isHidden = true
        loaderActivityIndicator.stopAnimating()
    }

    private func presentAlert(with title: String, and msg: String? = nil) {
        showAlert(title: title, message: msg)
    }

    // MARK: Actions
    @IBAction private func tapShareEvent(_ sender: UIButton) {
        let textToShare = viewModel.eventTitle

        var objectsToShare: [Any] = [textToShare]
        if let image = eventImageView.image {
            objectsToShare.append(image)
        }

        viewModel.shareObjects(objectsToShare)
    }

    @IBAction private func tapCheckin(_ sender: Any) {
        viewModel.checkIn()
    }
}
