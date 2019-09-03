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
    private var lastValue: Value?
    private var queue: DispatchQueue = DispatchQueue.main

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
        // If we already have a value available, we'll give the
        // handler access to it directly.
        lastValue.map {
            callObserver(for: object, with: $0, handler: handler)
        }

        // Each observation closure returns a Bool that indicates
        // whether the observation should still be kept alive,
        // based on whether the observing object is still retained.
        observations.append { [weak object] value in
            guard let object = object else {
                return false
            }
            self.callObserver(for: object, with: value, handler: handler)
            return true
        }
    }

    private func callObserver<O: AnyObject>(for object: O,
                                            with value: Value,
                                            handler: @escaping (O, Value) -> Void) {
        //Jumping queues https://www.swiftbysundell.com/posts/reducing-flakiness-in-swift-tests
        if Thread.isMainThread {
            handler(object, value)
        } else {
            queue.async {
              	handler(object, value)
            }
        }
    }
}

extension Bindable {
    @discardableResult
    func receive(on queue: DispatchQueue) -> Bindable {
        self.queue = queue
        return self
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
