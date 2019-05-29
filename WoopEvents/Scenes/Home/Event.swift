//
//  HomeObject.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

typealias Events = [Event]

struct Event: Decodable {
    let id, title: String
    let price: Double
    let latitude, longitude: Itude
    let image: String
    let eventDescription: String
    let date: Date
    let people: [Person]
    let cupons: [Cupon]

    enum CodingKeys: String, CodingKey {
        case id, title, price, latitude, longitude, image
        case eventDescription = "description"
        case date, people, cupons
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(Double.self, forKey: .price)
        latitude = try container.decode(Itude.self, forKey: .latitude)
        longitude = try container.decode(Itude.self, forKey: .longitude)
        image = try container.decode(String.self, forKey: .image)
        eventDescription = try container.decode(String.self, forKey: .eventDescription)
        let dateInt = try container.decode(Int.self, forKey: .date)
        date = Date(timeIntervalSince1970: TimeInterval(dateInt / 1000))
        people = try container.decode([Person].self, forKey: .people)
        cupons = try container.decode([Cupon].self, forKey: .cupons)
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

enum Itude: Decodable {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
            return
        }
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }
        throw DecodingError.typeMismatch(Itude.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Wrong type for Itude"))
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
