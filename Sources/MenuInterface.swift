// MenuInterface.swift Created by mason on 2017-01-20. 

import Foundation


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
            return "error: \(self) has no more inputs to read"
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
