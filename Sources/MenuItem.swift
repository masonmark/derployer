// MenuItem.swift Created by mason on 2017-01-20.


public class MenuItem: DerpSerializable {
    
    /// The name of the item (may be an identifier, should probably be unique for most use cases).
    public var name: String = ""
    
    /// The actual primitive value is always a string
    public var value: String = ""
    
    public var validator: MenuItemValidator? = nil
    
    public var type: MenuItemType = .string
    
    public var predefinedValues: [String]? = nil
    
    public required init() {
        
    }
    
    public init(_ name: String, value: String = "", validator: MenuItemValidator? = nil, type: MenuItemType = .string, predefinedValues: [String]? = nil) {
        
        self.name      = name
        self.value     = value
        self.validator = validator
        self.type      = type
        self.predefinedValues = predefinedValues
    }
    
    public func run(interface: MenuInterface, message: String? = nil) {
        
        if (type == .boolean) {
            if let boolVal = Bool(value) {
                self.value = String(!boolVal)
            } else {
                self.value = String(true)
            }
            return
        }
        
        if let message = message {
            interface.write("\n")
            interface.write(message)
            interface.write("\n\n")
        }
        
        let prompt = messageAcceptOrManuallyChangeValue(name: name, value: value)
        interface.write(prompt)
        let input = interface.read()
        
        if input == "" {
        
            interface.write(messageNoChangeMade())
        
        } else if !validate(input) {
            
            let warning = messageBadInputPleaseTryAgain(input: input)
            run(interface: interface, message: warning)
            
        } else {
            value = input
            let changeMessage = messageValueChanged(name: name, newValue: input)
            interface.write(changeMessage)
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
        }
        return true
    }
    
    public func serialize() throws -> DerpSerializationValues {
        let k = SerializationKeys()
        return [
            k.name             : name,
            k.value            : value,
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
    
        guard let value = values[k.value] as? String else {
            throw DerpSerializableError.DeserializationFailed("required 'value' value not present")
        }
        self.value = value
        
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


extension MenuItem {
    
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
            let check = value == "true" ? "✓" : " " // other types should have two leading spaces to align
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
}


/// Experimental idea: validator

public typealias MenuItemValidator = ((String)->Bool)
