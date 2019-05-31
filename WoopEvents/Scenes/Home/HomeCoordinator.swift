//
//  HomeCoordinator.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let presenter: UINavigationController

    // MARK: Life Cycle
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    // MARK: - Functions
    func start() {
        let viewModel = HomeViewModel(navigationDelegate: self)
        let homeViewController = HomeTableViewController(viewModel: viewModel)
    
        presenter.pushViewController(homeViewController, animated: true)
    }
}

extension HomeCoordinator: HomeNavigationProtocol {
    func didSelectEvent(_ event: Event) {

    }
}
