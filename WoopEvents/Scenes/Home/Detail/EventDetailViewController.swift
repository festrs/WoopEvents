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
    let viewModel: EventDetailViewModelProtocol
    @IBOutlet private(set) weak var mapView: MKMapView!
    @IBOutlet private(set) weak var eventImageView: UIImageView!
    @IBOutlet private(set) weak var eventTitleLabel: UILabel!
    @IBOutlet private(set) weak var eventDayLabel: UILabel!
    @IBOutlet private(set) weak var eventMonthLabel: UILabel!
    @IBOutlet private(set) weak var eventDescriptionLabel: UILabel!
    @IBOutlet private(set) weak var eventTimeLabel: UILabel!
    @IBOutlet private(set) weak var shareButtonTitleLabel: UILabel!
    @IBOutlet private(set) weak var checkinButtonTitleLabel: UILabel!
    @IBOutlet private(set) weak var detailsLabel: UILabel!

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

    // MARK: Functions
    private func configBind() {
        eventImageView.kf.setImage(with: viewModel.eventImageUrl)
        eventTitleLabel.text = viewModel.eventTitle
        eventDayLabel.text = viewModel.eventDay
        eventMonthLabel.text = viewModel.eventMonth
        eventDescriptionLabel.text = viewModel.eventDescription
        eventTimeLabel.text = viewModel.eventFullDate

        configMap()
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

    // MARK: Actions
    @IBAction private func tapShareEvent(_ sender: UIButton) {
        let textToShare = viewModel.eventTitle

        let objectsToShare: [Any] = [textToShare, eventImageView.image]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
    }

    @IBAction private func tapCheckin(_ sender: Any) {
        viewModel.checkIn()
    }
}
