//
//  HomeTableViewCell.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit
import Kingfisher

final class HomeTableViewCell: UITableViewCell {
    static var identifier: String { return String.init(describing: self) }

    @IBOutlet private weak var eventImageView: UIImageView! {
        didSet {
            eventImageView.kf.indicatorType = .activity
        }
    }
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventDayLabel: UILabel!
    @IBOutlet private weak var eventMonthLabel: UILabel!
    @IBOutlet private weak var eventDescriptionLabel: UILabel!
    var viewModel: HomeCellViewModel?

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        config()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel?.imageDownloadCancellation.clearObservations()
    }

    // MARK: Functions
    private func config() {
        eventImageView.layer.cornerRadius = 4.0
        eventImageView.clipsToBounds = true
    }

    func config(viewModel: HomeCellViewModel) {
        viewModel.imageDownloadCancellation.addObservation(for: eventImageView) { (eventImageView, cancel) in
						guard cancel else { return }
            eventImageView.kf.cancelDownloadTask()
        }

        eventImageView.kf.setImage(with: viewModel.imageUrl)
        eventTitleLabel.text = viewModel.title
        eventDayLabel.text = viewModel.day
        eventMonthLabel.text = viewModel.month
        eventDescriptionLabel.text = viewModel.description
        self.viewModel = viewModel
    }
}
