//
//  MirrorObject.swift
//  WoopEventsTests
//
//  Created by Felipe Dias Pereira on 2019-07-26.
//  Copyright © 2019 FelipeP. All rights reserved.
//
import Foundation

class MirrorObject {
    let mirror: Mirror

    init(reflecting: Any) {
        self.mirror = Mirror(reflecting: reflecting)
    }

    func extract<T>(variableName: StaticString = #function) -> T? {
        return mirror.descendant("\(variableName)") as? T
    }
}
