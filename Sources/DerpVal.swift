/// A 'derp val' is a 'Derployer value', which is a single value that has a name and metadata associated with it, and is somehow meaningful to the deploy process. The metadata can be used to determine how to sensibly display UI for manipulating the value. E.g., if the type is `.boolean`, provide a toggle UI, if the type is `.string` and `predefinedValues` exist, let the user choose from a list, etc.

final public class DerpVal: DerpSerializable {
    
    public init() {
        self.identifier = ""
        self.type = .string
    }
    
    
    public init(_ identifier: String, type: DerpValType = .string, value: Any? = nil, predefinedValues: [String]? = nil) {
        
        self.identifier       = identifier
        self.type             = type
        self.value            = value
        self.predefinedValues = predefinedValues
    }
    
    
    /// Identifier for the DerpVar. Typically this is a unique value, but DerpVar itself doesn't impose any restrictions; it just stores the value.
    
    public var identifier: String
    
    
    /// The type controls what `value` is allowed to be.
    
    public private(set)var type: DerpValType
    
    
    /// The value of the DerpVar can be anything.
    
    public var value: Any?

    
    /// Predefined string values that are either suggested for convenience (no validation), or can be used to restrict the possible values (if the DerpValidator.predefinedOnly validator is used).
    
    public var predefinedValues: [String]?
    
    
    public var helpInfo: String?
    
    
    public func serialize() throws -> DerpSerializationValues {
        
        return [
            key(.identifier)       : identifier,
            key(.type)             : type.rawValue,
            key(.value)            : value,
            key(.predefinedValues) : predefinedValues,
            key(.helpInfo)         : helpInfo
        ]
    }
    
    public func deserialize(_ values: DerpSerializationValues) throws {
        
        guard let identifier = values[key(.identifier)] as? String else {
            throw DerpSerializableError.DeserializationFailed("no identifier present in source representation: values")
        }
        self.identifier = identifier
        
        if let typeName = values[key(.type)] as? String {
            
            guard let type = DerpValType(rawValue: typeName) else {
                throw DerpSerializableError.DeserializationFailed("no identifier present in source representation: values")
            }
            self.type = type
        }
        
        if let value = values[key(.value)] {
            self.value = value
        }
        
        if let predefinedValues = values[key(.predefinedValues)] as? [String] {
            self.predefinedValues = predefinedValues
        }
        
        if let helpInfo = values[key(.helpInfo)] as? String {
            self.helpInfo = helpInfo
        }
    }
    
    
    /// Returns `false` (i.e. validation failed) if any validator in `self.validators` returns `false`. Returns true if every validator returns true.
    
    public func validate(_ proposedValue: Any) -> Bool {
        
        for validator in validators {
            
            guard validator(self, proposedValue) else {
                return false
            }
        }
        return true
    }
    
    
    /// Returns an array of validators, which are based on the DerpVal's type; `validate()` will return false unless all validators are satisfied.
    
    private var validators: [DerpValidator] {
        switch type {
        case .string:
            return [DerpValidators.isString]
        case .boolean:
            return [DerpValidators.isBool]
        case .predefined:
            return [DerpValidators.isString, DerpValidators.isPredefinedValue]
        }
    }
}


public enum DerpValType: String {
    case string
    case boolean
    case predefined
    // YAGNI case list, integer...
}


public enum DerpValKey: String {
    case identifier
    case type
    case value
    case predefinedValues
    case helpInfo
}


extension DerpVal {
    
    public static func key(_ key: DerpValKey) -> String {
        return key.rawValue
    }
    public func key(_ key: DerpValKey) -> String {
        return key.rawValue
    }
}
