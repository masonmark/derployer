// MenuValue.swift Created by mason on 2017-02-08. 

import Foundation

/// MenuValue type restricts what a Menu's value can be.

public protocol MenuValue {
    
    // Must convert the reciever to a String, used for both serialization (to a JSON-compatible value for e.g. storing in a file) and also for displaying textually in a CLI menu.

    func toString() -> String
    
    // Updates the value from its string representation, returning true on success, false otherwise.
    
    mutating func updateFrom(string: String) -> Bool
}


extension MenuValue {
    
    var boolValue: Bool {
        guard let val = self as? Bool else {
            return false
        }
        return val
    }
}


extension String: MenuValue {
    
    public func toString() -> String {
        return self
    }
    
    
    public mutating func updateFrom(string: String) -> Bool {
        self.removeAll()
        self.append(string)
        return true
    }
    
    
    public func makeMenuValue(type: MenuItemType) -> MenuValue {
        var result: MenuValue
        switch type {
        case .boolean:
            result = Bool(self) ?? false
        default:
            result = String(self)
        }
        return result
    }
}


extension Bool: MenuValue {
    
    public func toString() -> String {
        return String(self)
    }
    
    
    public mutating func updateFrom(string: String) -> Bool {
        guard let newValue = Bool(string) else {
            return false
        }
        self = newValue
        return true
    }
}


// MASON 2017-02-07: This is still experimental.... not doing this yet:
//
//extension Array where Element == MenuItem {
//    // Above line's syntax intro'd in Swift 3.1: http://stackoverflow.com/a/40214792/164017
//
//    func toString() -> String {
//        return "hhoop"
//    }
//    mutating func takeValue(string: String) -> Bool {
//        return true
//    }
//}
