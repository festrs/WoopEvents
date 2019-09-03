//
//  ServiceModelController.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-08-06.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

protocol ServiceModelControllerProtocol: AnyObject {
    var requestModel: Bindable<RequestViewModel> { get }
}

struct RequestViewModel {
    var loading: Bool
    var error: String?
    var errorTitle: String?
}

extension RequestViewModel {
    static func loading(isLoading: Bool) -> RequestViewModel {
        return RequestViewModel(loading: isLoading,
                                error: nil,
                                errorTitle: nil)
    }

    static func error(title: String, message msg: String) -> RequestViewModel {
        return RequestViewModel(loading: false,
                                error: msg,
                                errorTitle: title)
    }
}
