//
//  DateFormatterTests.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import XCTest
@testable import WoopEvents

class DateFormatterTests: XCTestCase {

    func testDayDateFormatter() {
        XCTAssertEqual(DateFormatter.dayDateFormat.dateFormat, "dd")

        let date = DateFormatter.dayDateFormat.date(from: "23")

        guard let unDate = date else {
            XCTFail("error passing date with brazilian format")
            return
        }

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: unDate)
        XCTAssertEqual(dateComponents.day, 23)
    }

    func testShortMonthBrazilianDateFormat() {
        XCTAssertEqual(DateFormatter.shortMonthBrazilianDateFormat.dateFormat, "MMM")

        let date = DateFormatter.shortMonthBrazilianDateFormat.date(from: "JAN")

        guard let unDate = date else {
            XCTFail("error passing date with shortMonth format")
            return
        }

        let dateComponents = Calendar.current.dateComponents([.month], from: unDate)

        XCTAssertEqual(dateComponents.month, 01)
    }
}
