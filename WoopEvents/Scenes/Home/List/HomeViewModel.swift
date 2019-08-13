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

protocol HomeViewModelProtocol: ServiceModelControllerProtocol {
    var updateHandler: () -> Void { get set }
    var title: String { get }
    var errorIsHidden: Bindable<Bool> { get }
    var emptyMsg: String { get }

    func getImagesUrls(at indexPaths: [IndexPath]) -> [URL]
    func eventsCount() -> Int
    func fetchEvents()
    func didTapCell(at indexPath: IndexPath)
    func getObject(at row: Int) -> HomeCellViewModelProtocol?
}

class HomeViewModel {
    var updateHandler: () -> Void = {}
    var requestModel: Bindable<RequestViewModel>  = Bindable(.loading(isLoading: false))
    var title: String = String.localized(by: "HomeTitle")
    var emptyMsg: String = String.localized(by: "HomeEmptyMsg")
    var errorIsHidden: Bindable<Bool> = Bindable(true)
    private weak var navigationDelegate: HomeNavigationProtocol?
    private var service: HomeServiceProtocol
    private var events: [HomeCellViewModelProtocol] = []

    init(service: HomeServiceProtocol = HomeService(),
         navigationDelegate: HomeNavigationProtocol? = nil) {
        self.service = service
        self.navigationDelegate = navigationDelegate
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func getImagesUrls(at indexPaths: [IndexPath]) -> [URL] {
        let validIndexPaths = indexPaths.map { $0.row }
        let eventsUrls = events.enumerated().lazy.filter {
            validIndexPaths.contains($0.offset)
        }.compactMap { (_, object) in
            return object.event.image
        }
        return Array(eventsUrls)
    }

    func fetchEvents() {
    	requestModel.update(with: .loading(isLoading: true))
        service.request(path: .fetchEvents) { result in
            self.requestModel.update(with: .loading(isLoading: false))

            switch result {
            case .success(let objects):
                self.errorIsHidden.update(with: true)
                self.events = objects.lazy.map { HomeCellViewModel(event: $0) }.sorted(by: \.event.date)
                if Thread.isMainThread {
					self.updateHandler()
                } else {
                    DispatchQueue.main.async {
                        self.updateHandler()
                    }
                }

            case .failure(let error):
                self.errorIsHidden.update(with: false)
                self.requestModel.update(with: .error(title: "",
                                                      message: error.localizedDescription))
            }
        }
    }

    func getObject(at row: Int) -> HomeCellViewModelProtocol? {
        guard events.indices.contains(row) else {
            return nil
        }
        return events[row]
    }

    func didTapCell(at indexPath: IndexPath) {
        guard events.indices.contains(indexPath.row) else {
            return
        }
        let event = events[indexPath.row].event
        navigationDelegate?.didSelectEvent(event)
    }

    func eventsCount() -> Int {
        return events.count
    }
}
