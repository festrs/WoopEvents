//
//  HomeCellViewModel.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit

final class HomeCellViewModel {
    let event: Event
    let imageUrl: URL
    let day: String
    let month: String
    let title: String
    let description: String
    var imageDownloadCancellation: Bindable<Bool> = Bindable(false)

    init(event: Event) {
        self.event = event
        title = event.title
        description = event.eventDescription
        day = DateFormatter.dayDateFormat.string(from: event.date)
        month = DateFormatter.shortMonthBrazilianDateFormat.string(from: event.date)
        imageUrl = event.image
    }
}

extension HomeCellViewModel: SelfConstructedUITableViewCell {
    func makeCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier,
                                                       for: indexPath) as? HomeTableViewCell else {
                                                        preconditionFailure("Failure")
        }
        cell.config(viewModel: self)
        return cell
    }

    func cancelImageDownload() {
        imageDownloadCancellation.update(with: true)
    }
}
