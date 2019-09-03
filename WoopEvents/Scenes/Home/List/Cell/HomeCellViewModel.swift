//
//  HomeCellViewModel.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

protocol HomeCellViewModelProtocol: AnyObject {
    var imageUrl: URL { get }
    var title: String { get }
    var day: String { get }
    var month: String { get }
    var description: String { get }
    var event: Event { get }
    var imageDownloadCancellation: Bindable<Bool> { get }

    func cancelImageDownload()
}

class HomeCellViewModel {
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

extension HomeCellViewModel: HomeCellViewModelProtocol {
    func cancelImageDownload() {
        imageDownloadCancellation.update(with: true)
    }
}
