//
//  EncodableTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-31.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
@testable import WoopEvents

class EncodableTests: XCTestCase {
    var testObject: TestingEncodable!

    override func setUp() {
        super.setUp()

        testObject = TestingEncodable(title: "Titulo", subtitle: "Subtitulo", amount: 10.0)
    }

    func testObjectAsDictionary() {
        let dictionary: [String: Any] = ["title": "Titulo",
                          "subtitle": "Subtitulo",
                          "amount": 10.0]

        if let objectDictionary = try? testObject.asDictionary() {
            XCTAssertEqual(objectDictionary["title"] as? String, dictionary["title"] as? String)
            XCTAssertEqual(objectDictionary["subtitle"] as? String, dictionary["subtitle"] as? String)
            XCTAssertEqual(objectDictionary["amount"] as? Double, dictionary["amount"] as? Double)
        } else {
            XCTFail("Cannot parse object to dictionary")
        }
    }

}

struct TestingEncodable: Encodable {
    var title: String
    var subtitle: String
    var amount: Double
}
