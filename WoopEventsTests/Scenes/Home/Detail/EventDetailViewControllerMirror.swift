//
//  EventDetailViewControllerMirror.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-07-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import UIKit
import MapKit
@testable import WoopEvents

final class EventDetailViewControllerMirror: MirrorObject {
    init(viewController: UIViewController) {
        super.init(reflecting: viewController)
    }
    
    var checkinButton: UIButton? {
        return extract()
    }
    var shareButton: UIButton? {
        return extract()
    }
}
