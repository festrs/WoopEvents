//
//  DateFormatter+Extension.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-30.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

public extension DateFormatter {
 	 static var dayDateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }

  	static var shortMonthBrazilianDateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }

  	static var fullDateEventDateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}
