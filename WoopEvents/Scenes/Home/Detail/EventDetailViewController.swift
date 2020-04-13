//
//  EventDetailViewController.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit
import MapKit

final class EventDetailViewController: UIViewController {
    private let viewModel: EventDetailViewModelProtocol
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventDayLabel: UILabel!
    @IBOutlet private weak var eventMonthLabel: UILabel!
    @IBOutlet private weak var eventDescriptionLabel: UILabel!
    @IBOutlet private weak var eventTimeLabel: UILabel!
    @IBOutlet private weak var shareButtonTitleLabel: UILabel!
    @IBOutlet private weak var checkinButtonTitleLabel: UILabel!
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var checkinButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var loaderActivityIndicator: UIActivityIndicatorView!
    private var alertError: Error? {
        didSet {
            if let alertError = alertError {
                showAlert(title: "Error", message: alertError.localizedDescription)
            }
        }
    }
    private var isLoading: Bool = false {
        didSet {
			isLoading ? showLoader() : hideLoader()
        }
    }

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
        eventTitleLabel.text = viewModel.eventTitle
        eventImageView.kf.setImage(with: viewModel.eventImageUrl)
        eventTitleLabel.text = viewModel.eventTitle
        eventDayLabel.text = viewModel.eventDay
        eventMonthLabel.text = viewModel.eventMonth
        eventDescriptionLabel.text = viewModel.eventDescription
        eventTimeLabel.text = viewModel.eventFullDate
        shareButtonTitleLabel.text = viewModel.sharedButtonTitle
        checkinButtonTitleLabel.text = viewModel.checkInButtonTitle
        detailsLabel.text = viewModel.detailsTitle

        configMap()

        viewModel.checkInResult.addObservation(for: self) { (viewController, checkInResult) in
            guard checkInResult.status else { return }

            viewController.presentAlert(with: checkInResult.title, and: checkInResult.msg)
        }

        viewModel.isLoading.bind(to: \.isLoading, on: self)
        viewModel.error.bind(to: \.alertError, on: self)
    }

    private func configMap() {
        let eventLocation = MKPointAnnotation()
        eventLocation.coordinate = viewModel.eventLocation
        mapView.addAnnotation(eventLocation)

        centerMapOnLocation(eventLocation.coordinate, mapView: mapView)
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
