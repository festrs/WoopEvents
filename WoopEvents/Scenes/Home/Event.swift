//
//  HomeObject.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

struct FailableDecodable<Base: Decodable>: Decodable {
    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}

typealias Events = [Event]

struct Event: Decodable {
    let id, title: String
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
    struct Cupon: Decodable {
        let id, eventID: String
        var discount: Int

        //swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case id
            case eventID = "eventId"
            case discount
        }
    }

    // MARK: - Person
    struct Person: Decodable {
        let id, eventID: String
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
