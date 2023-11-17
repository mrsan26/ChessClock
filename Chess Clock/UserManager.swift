//
//  UserManager.swift
//  Chess Clock
//
//  Created by Sanchez on 10.07.2023.
//

import Foundation
import UIKit

final class UserManager {
    static let manager = UserDefaults.standard
    
    enum Keys: String, CaseIterable {
        case colour
        case timerMode
    }
    
    
    static func read(_ key: Keys) -> String? {
        let value = manager.object(forKey: key.rawValue) as? String
        return value
    }
    
    static func read(_ key: Keys) -> Int? {
        let value = manager.object(forKey: key.rawValue) as? Int
        return value
    }
    
    static func write(value: String, for key: Keys) {
        manager.set(value, forKey: key.rawValue)
    }
    
    static func write(value: Int, for key: Keys) {
        manager.set(value, forKey: key.rawValue)
    }
    
    
    static func removeAll() {
        let allCases = Keys.allCases
        allCases.forEach { key in
            manager.set(nil, forKey: key.rawValue)
        }
    }
    
}
