// MenuItem.swift Created by mason on 2017-01-20.

public class MenuItem {
    
    public var value: String?
    
    public var name: String
    
    public var validator: MenuItemValidator? = nil
    
    public init(_ name: String, value: String? = nil, validator: MenuItemValidator? = nil) {
        
        self.name      = name
        self.value     = value
        self.validator = validator
    }
    
    public func run(interface: MenuInterface, message: String? = nil) {
        
        if let message = message {
            interface.write("\n")
            interface.write(message)
            interface.write("\n\n")
        }
        
        let displayValue = value ?? "<not set>"
        let prompt = "\(name): \(displayValue). Press ↩︎ to accept, or else enter a new value.\n"
        interface.write(prompt)
        let input = interface.read()
        
        if input == "" {
        
            interface.write("No change made.\n\n")
        
        } else if !validate(input) {
            
            let warning = "⚠️  SORRY: '\(input)' is not something I understand. Please try again."
            run(interface: interface, message: warning)
            
        } else {
            value = input
            interface.write("New value for \(name): \(input)\n\n")
        }
    }
    
    public func validate(_ input: String) -> Bool {
        guard let v = validator else {
            return true
        }
        return v(input)
    }
}


/// Experimental idea: validator
public typealias MenuItemValidator = ((String)->Bool)
