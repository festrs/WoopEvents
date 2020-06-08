//
//  AppCoordinator.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//
import UIKit
import Networking

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var rootViewController: UINavigationController = UINavigationController()
    private let window: UIWindow

    // MARK: - Initialization
    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Functions
    func start() {
        let homeCoordinator = HomeCoordinator(presenter: rootViewController)
        homeCoordinator.start()

        add(childCoordinator: homeCoordinator)

        guard let lastViewController = rootViewController.viewControllers.last else {
            fatalError("")
        }

        rootViewController.viewControllers = [lastViewController]

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
