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
    
    var eventTitleLabel: UILabel? {
        return extract()
    }
    var eventDayLabel: UILabel? {
        return extract()
    }
    var eventTimeLabel: UILabel? {
        return extract()
    }
    var eventDescriptionLabel: UILabel? {
        return extract()
    }
    var eventMonthLabel: UILabel? {
        return extract()
    }
    var mapView: MKMapView? {
        return extract()
    }
    var checkinButton: UIButton? {
        return extract()
    }
    var shareButton: UIButton? {
        return extract()
    }
}
