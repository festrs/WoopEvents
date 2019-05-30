//
//  HomeViewModel.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

protocol HomeNavigationProtocol: AnyObject {
    func didSelectEvent(_ event: Event)
}

protocol HomeViewModelProtocol: AnyObject {
    var loading: Dynamic<Bool> { get }
    var error: Dynamic<String?> { get }
    var events: Dynamic<[HomeCellViewModelProtocol]> { get }

    func getImagesUrls(at indexPaths: [IndexPath]) -> [URL]
    func eventsCount() -> Int
    func fetchEvents()
    func didTapCell(at indexPath: IndexPath)
    subscript(row: Int) -> HomeCellViewModelProtocol? { get }
}

class HomeViewModel {
    let error: Dynamic<String?> = Dynamic(nil)
    let events: Dynamic<[HomeCellViewModelProtocol]> = Dynamic([])
    let loading: Dynamic<Bool> = Dynamic(true)
    private var service: HomeServiceProtocol
    private weak var navigationDelegate: HomeNavigationProtocol?

    init(service: HomeServiceProtocol = HomeService(), navigationDelegate: HomeNavigationProtocol? = nil) {
        self.service = service
        self.navigationDelegate = navigationDelegate
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func getImagesUrls(at indexPaths: [IndexPath]) -> [URL] {
        let validIndexPaths = indexPaths.map { $0.row }
        let eventsUrls = events.value.map { $0.imageUrl }
        let eventsUrlsFiltred = eventsUrls.enumerated().filter {
            validIndexPaths.contains($0.offset)
        }.compactMap { (_, object) in
            return object
        }
        return eventsUrlsFiltred
    }

    func fetchEvents() {
        loading.value = true
        service.fetchEvents { result in
            self.loading.value = false

            switch result {
            case .success(let objects):
                self.events.value = objects.map { HomeCellViewModel(event: $0) }

            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }

    subscript(row: Int) -> HomeCellViewModelProtocol? {
        guard events.value.indices.contains(row) else {
            return nil
        }
        return events.value[row]
    }

    func didTapCell(at indexPath: IndexPath) {
        guard events.value.indices.contains(indexPath.row) else {
            return
        }
        let event = events.value[indexPath.row].event
        navigationDelegate?.didSelectEvent(event)
    }

    func eventsCount() -> Int {
        return events.value.count
    }
}
