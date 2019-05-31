//
//  RequestViewModelProtocol.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

protocol RequestViewModelProtocol: AnyObject {
    var loading: Dynamic<Bool> { get }
    var error: Dynamic<String?> { get }
}
