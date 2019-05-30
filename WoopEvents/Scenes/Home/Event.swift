//
//  HomeObject.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

typealias Events = [Event]

struct FailableDecodable<Base : Decodable> : Decodable {
    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}

struct Event: Decodable {
    let id, title: String
    let price: Double
    let latitude, longitude: Double
    let image: URL
    let eventDescription: String
    let date: Date
    let people: [Person]
    let cupons: [Cupon]

    enum CodingKeys: String, CodingKey {
        case id, title, price, latitude, longitude, image
        case eventDescription = "description"
        case date, people, cupons
    }
}

// MARK: - Cupon
struct Cupon: Decodable {
    let id, eventID: String
    let discount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "eventId"
        case discount
    }
}

// MARK: - Person
struct Person: Decodable {
    let id, eventID, name: String
    let picture: String

    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "eventId"
        case name, picture
    }
}
