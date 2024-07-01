//
//  Observers.swift
//  CoffeeApp
//
//  Created by Adam Khan on 5/30/24.
//

import Foundation

public struct Observers<T> {
    typealias Listeners = ((T) -> Void)
    private var listener: Listeners?
    var value: T? {
        didSet {
            if let value = value
            {
                listener?(value)
            }
            
        }
    }
    init(_ value: T?) {
        self.value = value
    }
    mutating func bind(_ listener: @escaping Listeners){
        listener(value!)
        self.listener = listener
    }
}
