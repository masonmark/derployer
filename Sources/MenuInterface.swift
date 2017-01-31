// MenuInterface.swift Created by mason on 2017-01-20. 

// FIXME: make MenuInterface provide the interface that MenuFormatter currently does. The formatter will then just be the implementation of how header() prompt() etc look. Then objects like MenuItem can use do prompts and headers as need be, without being coupled to MenuFormatter. (Currently MenuItem just writes raw-dog...)

/// Defines the means for a menu to interact with a user. (The "user" might be an automated test, instead of a person.)

public protocol MenuInterface {
    
    func read() -> String
    
    func write(_ output: String)
}


extension MenuInterface {
    
    func write(_ output: String, terminator: String = "\n") {
        
        let output = output + terminator
        write(output)
    }
}


/// A test-friendly interface for menus.

public class TestMenuInterface: MenuInterface {
    
    var inputs: [String]
    var outputs: [String]
    
    public init(inputs: [String] = [], outputs: [String] = []) {
        self.inputs = inputs;
        self.outputs = outputs;
    }
    
    public func read() -> String {
        guard self.inputs.count > 0 else {
            return ""
        }
        return self.inputs.remove(at: 0)
    }
    
    public func write(_ output: String) {
        self.outputs.append(output)
    }
    
    public var outputText: String {
        return self.outputs.joined(separator: "")
    }
}


/// The simplest possible actual menu interface.

public class DefaultMenuInterface: MenuInterface {
    
    public func read() -> String {
        guard let result = readLine() else {
            return "poo"
        }
        return result
    }
    
    public func write(_ output: String) {
        print(output)
    }

}
