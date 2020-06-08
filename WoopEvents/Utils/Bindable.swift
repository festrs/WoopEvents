//
//  Dynamic.swift
//  WoopEvents
//
//  Created by Felipe Dias Pereira on 2019-05-29.
//  Copyright © 2019 FelipeP. All rights reserved.
//

import Foundation

//https://www.swiftbysundell.com/posts/bindable-values-in-swift
class Bindable<Value> {
  private var observations = [(Value) -> Bool]()
  private(set) var lastValue: Value?

  init(_ value: Value? = nil) {
    lastValue = value
  }
}

extension Bindable {
  func update(with value: Value) {
    lastValue = value
    observations = observations.filter { $0(value) }
  }

  func addObservation<O: AnyObject>(
    for object: O,
    handler: @escaping (O, Value) -> Void
  ) {
    lastValue.map { value in
      if Thread.isMainThread {
        handler(object, value)
      } else {
        DispatchQueue.main.async {
          handler(object, value)
        }
      }
    }

    observations.append { [weak object] value in
      guard let object = object else {
        return false
      }
      if Thread.isMainThread {
        handler(object, value)
      } else {
        DispatchQueue.main.async {
          handler(object, value)
        }
      }
      return true
    }
  }
}

extension Bindable {
  func clearObservations() {
    observations.removeAll()
  }

  func bind<O: AnyObject>(to objectKeyPath: ReferenceWritableKeyPath<O, Value>,
                          on object: O) {
    addObservation(for: object) { (object, value) in
      object[keyPath: objectKeyPath] = value
    }
  }

  func bind<O: AnyObject, T>(
    _ sourceKeyPath: KeyPath<Value, T>,
    to object: O,
    _ objectKeyPath: ReferenceWritableKeyPath<O, T>
  ) {
    addObservation(for: object) { object, observed in
      let value = observed[keyPath: sourceKeyPath]
      object[keyPath: objectKeyPath] = value
    }
  }

  func bind<O: AnyObject, T>(
    _ sourceKeyPath: KeyPath<Value, T>,
    to object: O,
    _ objectKeyPath: ReferenceWritableKeyPath<O, T?>
  ) {
    addObservation(for: object) { object, observed in
      let value = observed[keyPath: sourceKeyPath]
      object[keyPath: objectKeyPath] = value
    }
  }

  func bind<O: AnyObject, T, R>(
    _ sourceKeyPath: KeyPath<Value, T>,
    to object: O,
    _ objectKeyPath: ReferenceWritableKeyPath<O, R?>,
    transform: @escaping (T) -> R?
  ) {
    addObservation(for: object) { object, observed in
      let value = observed[keyPath: sourceKeyPath]
      let transformed = transform(value)
      object[keyPath: objectKeyPath] = transformed
    }
  }
}
