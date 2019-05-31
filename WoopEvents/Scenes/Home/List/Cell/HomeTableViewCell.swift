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
    static let identifier = "HomeTableViewCell"

    @IBOutlet private(set) weak var eventImageView: UIImageView! {
        didSet {
            eventImageView.kf.indicatorType = .activity
        }
    }
    @IBOutlet private(set) weak var eventTitleLabel: UILabel!
    @IBOutlet private(set) weak var eventDayLabel: UILabel!
    @IBOutlet private(set) weak var eventMonthLabel: UILabel!
    @IBOutlet private(set) weak var eventDescriptionLabel: UILabel!
    var viewModel: HomeCellViewModelProtocol!

    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()

        config()
    }

    // MARK: Functions
    private func config() {
        eventImageView.layer.cornerRadius = 4.0
        eventImageView.clipsToBounds = true
    }

    func config(viewModel: HomeCellViewModelProtocol) {
        viewModel.imageDownloadCancellation.bind { [weak self] cancel in
            guard let self = self, cancel else { return }
            self.eventImageView.kf.cancelDownloadTask()
        }

        eventImageView.kf.setImage(with: viewModel.imageUrl)
        eventTitleLabel.text = viewModel.title
        eventDayLabel.text = viewModel.day
        eventMonthLabel.text = viewModel.month
        eventDescriptionLabel.text = viewModel.description
        self.viewModel = viewModel
    }
}
