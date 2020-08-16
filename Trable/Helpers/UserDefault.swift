//
//  UserDefault.swift
//  Trable
//
//  Created by nc on 16.08.20.
//

import Foundation

@propertyWrapper
public struct UserDefault<T: Any> {
    public let key: String
    public let defaultValue: T
    
    init(key: String, defaultValue: T)
    {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

