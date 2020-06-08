//
//  EventsStub.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-07-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation
@testable import WoopEvents

extension EventCheckInResponseObject: Stubbable {
    static func stub(withID id: String) -> EventCheckInResponseObject {
        return EventCheckInResponseObject(code: id)
    }
}

extension Event: Stubbable {
    static func stub(withID id: String) -> Event {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"

        let event = Event(id: "123",
                          title: "Encontro regional ONGS",
                          price: 10.0,
                          latitude: 11.0,
                          longitude: 10.0,
                          //swiftlint:disable force_unwrapping
            image: URL(string: "http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png")!,
            eventDescription: "Encontro para discutir soluções voltadas a engajamento e captação de recursos",
            //swiftlint:disable force_unwrapping
            date: dateFormatter.date(from: "23/09/1990 06:00")!,
            people: [],
            cupons: [])
        return event
    }
}
