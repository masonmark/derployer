// MenuItem.swift Created by mason on 2017-01-20.

// FIXME?: Mason 2017-02-05: I think what it messy here is that MenuItem and Menu are too conflated and mixed up. Menu should maybe do ALL direct input processing -- and menu items should only process input passed to them from a Menu. (And maybe Menu is the wrong word... :-/ but can't think of anything more apt for "screen-like display of information that accepts some sort of user input for some purpose (perhaps just acknowledgement) )

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
    
    
//    /// If `string` can be converted for a value type that is appropriate for the reciever (e.g., if the receiver's type is .boolean, then string is "true" or "false" (can be used to init a Bool)), this returns the value. Returns nil if string is invalid for the receiver's type.
//    
//    public func makeValueFrom(string: String) -> MenuItemValue? {
//        // FIXME: delete this in favor of String:MenuItemValue's makeMenuItemValue(type:) ?
//    }
    
    
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


extension MenuItem: CustomStringConvertible {
    
    /// Returns a string suitable for use in a menu (item in a list of items).
    
    public var description: String {
        switch type {
        case .boolean:
            let check = value.boolValue ? "✓" : " " // other types should have two leading spaces to align
            return "\(check) \(name)"
        case .userInput:
            return "  <enter other value>"
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


/// Depending on the usage scenario, menu items may need to validate input and reject unusable values. There are some built in validators for common cases, but by implementing a MenuItemValidator you can do any kind of validation.

public typealias MenuItemValidator = ((String)->Bool)
