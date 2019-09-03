//
//  AppDelegate.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var applicationCoordinator: AppCoordinator?

    //swiftlint:disable discouraged_optional_collection
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let cache = ImageCache.default
        // Limit memory cache to hold 10 images at most.
        cache.memoryStorage.config.countLimit = 10
        // Limit disk cache size to 50 MB.
        cache.diskStorage.config.sizeLimit = 50 * 1024 * 1024

        let applicationCoordinator = AppCoordinator(window: window)

        self.window = window
        self.applicationCoordinator = applicationCoordinator

        applicationCoordinator.start()
        return true
    }
}
