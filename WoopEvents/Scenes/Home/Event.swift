//
//  HomeObject.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

typealias Events = [Event]

struct Event: Identifiable, Codable {
    let id: Identifier<Event>
    let title: String
    var price: Double
    var latitude, longitude: Double
    var image: URL
    var eventDescription: String
    var date: Date
    var people: [Person]
    var cupons: [Cupon]

    enum CodingKeys: String, CodingKey {
        case id, title, price, latitude, longitude, image
        case eventDescription = "description"
        case date, people, cupons
    }

    // MARK: - Cupon
    struct Cupon: Identifiable, Codable {
        let id: Identifier<Event.Cupon>
      	let eventID: Identifier<Event>
        var discount: Int

        //swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case id
            case eventID = "eventId"
            case discount
        }
    }

    // MARK: - Person
    struct Person: Identifiable, Codable {
      	let id: Identifier<Event.Person>
      	let eventID: Identifier<Event>
        var name: String
        var picture: String

        //swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case id
            case eventID = "eventId"
            case name, picture
        }
    }
}
