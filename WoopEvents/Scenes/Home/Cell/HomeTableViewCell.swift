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

    @IBOutlet private weak var eventImageView: UIImageView! {
        didSet {
            eventImageView.kf.indicatorType = .activity
        }
    }
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventDayLabel: UILabel!
    @IBOutlet private weak var eventMonthLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
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
    }
}
