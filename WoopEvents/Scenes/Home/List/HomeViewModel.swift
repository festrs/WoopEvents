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
    var updateHandler: () -> Void { get set }
    var title: String { get }
    var errorIsHidden: Bindable<Bool> { get }
    var stringError: Bindable<String?> { get }
    var emptyMsg: String { get }
    var loading: Bindable<Bool> { get }
	var tableDataSource: TableViewModelDataSource<HomeCellViewModel> { get }
    
    func getImagesUrls(at indexPaths: [IndexPath]) -> [URL]
    func fetchEvents()
    func didTapCell(at indexPath: IndexPath)
}

final class HomeViewModel {
    typealias EventsListResponse = Result<[Event], Error>
    
    var updateHandler: () -> Void = {}
    let title: String = localized(by: "HomeTitle")
    let emptyMsg: String = localized(by: "HomeEmptyMsg")
    let errorIsHidden: Bindable<Bool> = Bindable()
    let stringError: Bindable<String?> = Bindable()
    let loading: Bindable<Bool> = Bindable()
    var tableDataSource: TableViewModelDataSource<HomeCellViewModel> = TableViewModelDataSource(items: [])
    private weak var navigationDelegate: HomeNavigationProtocol?
    private var service: DataRequestable

    init(service: DataRequestable = Service(),
         navigationDelegate: HomeNavigationProtocol? = nil) {
        self.service = service
        self.navigationDelegate = navigationDelegate
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func getImagesUrls(at indexPaths: [IndexPath]) -> [URL] {
        let urls = indexPaths.lazy.compactMap { self.tableDataSource.getObject(at: $0) }.map { $0.imageUrl }

        return Array(urls)
    }

    func fetchEvents() {
        loading.update(with: true)

        service.request(.eventList) { (result: EventsListResponse) in
            self.loading.update(with: false)

            switch result {
            case .success(let objects):
                self.errorIsHidden.update(with: true)
                let events = objects.map { HomeCellViewModel(event: $0) }.sorted(by: \.event.date)
                self.tableDataSource.update(with: [events])

                if Thread.isMainThread {
                    self.updateHandler()
                } else {
                    DispatchQueue.main.async {
                        self.updateHandler()
                    }
                }

            case .failure(let error):
                self.errorIsHidden.update(with: false)
                self.stringError.update(with: error.localizedDescription)
            }
        }
    }

    func didTapCell(at indexPath: IndexPath) {
        guard let object = tableDataSource.getObject(at: indexPath) else {
            return
        }
        let event = object.event
        navigationDelegate?.didSelectEvent(event)
    }
}
