// MenuItem.swift Created by mason on 2017-01-20.

public class MenuItem {
    
    public var value: String?
    
    public var name: String
    
    public init(_ name: String, value: String? = nil) {
        
        self.name  = name;
        self.value = value;
    }
    
    public func run(interface: MenuInterface) {
        
        let displayValue = value ?? "<not set>"
        let prompt = "\(name): \(displayValue). Press ↩︎ to accept, or else enter a new value.\n"
        interface.write(prompt)
        let input = interface.read()
        
        if input == "" {
            interface.write("No change made.\n\n")
        } else {
            value = input
            interface.write("New value for \(name): \(input)\n\n")
        }
    }
}
