//
//  CoordinatorProtocols.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    @discardableResult func add(childCoordinator: Coordinator) -> Coordinator
    @discardableResult func remove(childCoordinator: Coordinator) -> Coordinator
}

extension Coordinator {
    @discardableResult
    func add(childCoordinator: Coordinator) -> Coordinator {
        self.childCoordinators.append(childCoordinator)

        return childCoordinator
    }

    @discardableResult
    func remove(childCoordinator: Coordinator) -> Coordinator {
        self.childCoordinators.removeAll { $0 === childCoordinator }

        return childCoordinator
    }
}
