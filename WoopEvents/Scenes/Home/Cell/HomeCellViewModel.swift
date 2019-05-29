//
//  HomeCellViewModel.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

protocol HomeCellViewModelProtocol: AnyObject {
    var event: Event { get }
}

class HomeCellViewModel {
    var event: Event

    init(event: Event) {
        self.event = event
    }
}

extension HomeCellViewModel: HomeCellViewModelProtocol {}
