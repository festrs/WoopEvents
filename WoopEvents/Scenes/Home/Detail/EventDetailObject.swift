//
//  EventDetailObject.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

struct EventCheckInRequestObject: Encodable {
    var eventId: Identifier<Event>
    var name: String
    var email: String
}

struct EventCheckInResponseObject: Decodable {
    var code: String
}
