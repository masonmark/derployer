// MenuItem.swift Created by mason on 2017-01-20.

// Mason 2017-02-05: I think what it messy here is that MenuItem and Menu are too conflated and mixed up.
// Menu should maybe do ALL direct input processing -- and menu items should only process input passed t



public protocol MenuItemValue {
    func toString() -> String
    mutating func updateFrom(string: String) -> Bool
}

extension MenuItemValue {
    
    var boolValue: Bool {
        guard let val = self as? Bool else {
            return false
        }
        return val
    }
}

extension String: MenuItemValue {
    public func toString() -> String {
        return self
    }
    public mutating func updateFrom(string: String) -> Bool {
        self.removeAll()
        self.append(string)
        return true
    }
    
    
    public func makeMenuItemValue(type: MenuItemType) -> MenuItemValue {
        var result: MenuItemValue
        switch type {
        case .boolean:
            result = Bool(self) ?? false
        default:
            result = String(self)
        }
        return result
    }

}

extension Bool: MenuItemValue {
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





public class MenuItem: DerpSerializable, MenuInterlocutor {
    
    /// The name of the item (may be an identifier, should probably be unique for most use cases).
    public var name: String = ""
    
    public var value: MenuItemValue = "" // FIXME should be MenuItemValue?
    
    public var stringValue: String {
        return value.toString()
    }
    
    public var boolValue: Bool {
        return value.boolValue
    }
    
    
    public var validator: MenuItemValidator? = nil
    
    public var type: MenuItemType = .string
    
    public var predefinedValues: [String]? = nil
    
    public required init() {
        
    }
    
    public init(_ name: String, value: MenuItemValue = "", validator: MenuItemValidator? = nil, type: MenuItemType = .string, predefinedValues: [String]? = nil) {
        
        self.name      = name
        self.value     = value
        self.validator = validator
        self.type      = type
        self.predefinedValues = predefinedValues
    }
    
    public convenience init(staticValue: String) {
        self.init(staticValue, value: staticValue, type: .staticValue)
    }
    
    /// Run updates the MenuItem's value, and returns it. To "update" the value means something different depending on the type. It might just toggle a boolean flag; it might run a series of menus and interact with the user to build/confirm a more complex value.
    
    public func run(interface: MenuInterface, message: String? = nil) -> MenuItemValue {
        
        if let message = message {
            interface.write("\n")
            interface.write(message)
            interface.write("\n\n")
        }
        
        if type == .staticValue {
            return value
        }
        
        if type == .boolean {
            value = !value.boolValue
            return value
        }
        
        if type == .userInput {
            let prompt = messageAcceptOrManuallyChangeValue(name: name, value: value.toString())
            interface.write(prompt)
            value = interface.read()
            return value
        }
        
        if type == .predefined || predefinedValues != nil {
            let allowed = predefinedValues ?? []
            let menu = Menu(forSelectingPredefinedValue: allowed, only: type == .predefined, current: stringValue)
            menu.interface = interface
            
            guard let result = menu.run() as? String else {
                fatalError("FIXME: how should this be handled?")
            }
            value = result
            return value
        }
        
        let prompt = messageAcceptOrManuallyChangeValue(name: name, value: value.toString())
        interface.write(prompt)
        let input = interface.read()
        
        if input == "" {
        
            interface.write(messageNoChangeMade())
            return value
        
        } else if !validate(input) {
            
            let warning = messageBadInputPleaseTryAgain(input: input)
            return run(interface: interface, message: warning)
            
        } else {
            value = input
            let changeMessage = messageValueChanged(name: name, newValue: input)
            interface.write(changeMessage)
            return value
        }
    }
    
    public func validate(_ input: String) -> Bool {
        
        if let v = validator {
            return v(input)
        
        } else if type == .boolean {
            return Bool(input) != nil
        
        } else if type == .predefined {
            guard let allowed = predefinedValues else {
                return false
            }
            return allowed.contains(input)
        
        } else if type == .staticValue {
            return input == value.toString()
        }
        return true
    }
    
    public func serialize() throws -> DerpSerializationValues {
        let k = SerializationKeys()
        return [
            k.name             : name,
            k.value            : value.toString(),
            k.type             : type.rawValue,
            k.predefinedValues : predefinedValues
        ]
    }
    
    public func deserialize(_ values: DerpSerializationValues) throws {
    
        let k = SerializationKeys()

        guard let name = values[k.name] as? String else {
            throw DerpSerializableError.DeserializationFailed("required 'name' value not present")
        }
        self.name = name
        
        guard let typeName = values[k.type] as? String, let type = MenuItemType(rawValue: typeName) else {
            throw DerpSerializableError.DeserializationFailed("invalid MenuItemType value")
        }
        self.type = type
    
        guard let valueString = values[k.value] as? String else {
            throw DerpSerializableError.DeserializationFailed("required 'value' value not present")
        }
        self.value = valueString.makeMenuItemValue(type: self.type)
        
        if let predefinedValues = values[k.predefinedValues] as? [String] {
            self.predefinedValues = predefinedValues
        }
    }
    
    private struct SerializationKeys {
        let name             = "name"
        let value            = "value"
        let type             = "type"
        let predefinedValues = "predefinedValues"
        
    }
}


protocol MenuInterlocutor {
}

extension MenuInterlocutor {
    
    public func messageAcceptOrManuallyChangeValue(name: String, value:String) -> String {
        return "\(name): \(value). Press ↩︎ to accept, or else enter a new value.\n"
    }
    
    public func messageBadInputPleaseTryAgain(input: String) -> String {
        return "⚠️  SORRY: '\(input)' is not something I understand. Please try again."
    }
    
    public func messageValueChanged(name: String, newValue: String) -> String {
        return "New value for \(name): \(newValue)\n\n"
    }
    
    public func messageNoChangeMade() -> String {
        return "No change made.\n\n"
    }
}


extension MenuItem: CustomStringConvertible {
    
    /// Returns a string suitable for use in a menu (item in a list of items).
    
    public var description: String {
        switch type {
        case .boolean:
            let check = value.boolValue ? "✓" : " " // other types should have two leading spaces to align
            return "\(check) \(name)"
        default:
            return "  \(name): \(value)"
        }
    }
}


/// Defines all menu item types, which control how they appear and behave.

public enum MenuItemType: String {
    
    /// The `.boolean` type is presented with the name and, if value equates to true, a checkbox next to it. When run it simply toggles its value and returns.
    
    case boolean
    
    /// The `.string` type is presented like "`  name: value`" and when run it presents a menu for editing its string value (which may include selecting from list (if the item has predefined values) or entering a value directly)
    
    case string
    
    
    /// The `.predefined` type is presented like "`  name: value`" and when run it presents a menu for selecting one of the predefined values.
    
    case predefined
    
    /// The `.staticValue` type just has a String value that doesn't change.
    
    case staticValue
    
    /// The `.userInput` type prompts user for a string.
    
    case userInput
}


/// Experimental idea: validator

public typealias MenuItemValidator = ((String)->Bool)
