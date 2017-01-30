// DerpValidator.swift Created by mason on 2017-01-28. 


/// Defines the type for DerpVal validation functions.

public typealias DerpValidator = ((DerpVal, Any) -> Bool)


/// Simple struct to house all built-in validators. Validators can be combined. Validators also control how values are disambiguated when a DerpVal is deserialized from text (JSON).

public struct DerpValidators {
    
    
    /// Returns true only if `proposedValue` is `true` or `false`.
    
    public static let isBool: DerpValidator = { (derpVal: DerpVal, proposedValue: Any) in
        
        return proposedValue is Bool
    }
    
    
    /// Returns true only if `proposedValue` is a string.
    
    public static let isString: DerpValidator = { (derpVal: DerpVal, proposedValue: Any) in
        
        return proposedValue is String
    }
    
    
    /// Returns true only if `proposedValue` is one of
    
    public static let isPredefinedValue: DerpValidator = { (derpVal: DerpVal, proposedValue: Any) in
        
        guard let proposedValue = proposedValue as? String else {
            return false
        }
        guard let allowed = derpVal.predefinedValues else {
            return false
        }
        return allowed.contains(proposedValue)
    }
    
    
    // YAGNI: custom validators
    
    
    /// Returns the validator named `name`, or `nil` if no validator with that name is defined. This is used when deserializing from text.
    
    public static func validator(name: String) -> DerpValidator? {
        
        switch name {
            
            case "bool":
                return isBool
                
            case "predefinedOnly":
                return isPredefinedValue
                
            default:
                return nil
        }
    }
}
