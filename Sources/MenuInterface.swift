// MenuInterface.swift Created by mason on 2017-01-20. 

/// Defines the means for a menu to interact with a user. (The "user" might be an automated test, instead of a person.)

public protocol MenuInterface: MenuFormatter {
    
    func read() -> String
    
    func write(_ output: String)
}


extension MenuInterface {
    
    public var formatter: MenuFormatter {
        // YAGNI? custom menu formatters
        return self
    }
    
    func writeResultsMessage(_ resultsMessage: String) {
        write(formatter.resultsMessage(resultsMessage))
    }
    
    func writeTitle(_ title: String) {
        write(formatter.title(title))
    }
    
    func writeHeader(_ header: String) {
        write(formatter.header(header))
    }

    func writeContent(_ content:[MenuItem]) {
        write(formatter.content(content))
    }
    
    func writeFooter(_ footer: String) {
        write(formatter.footer(footer))
    }
    
    func writePrompt(_ prompt: String) {
        write(formatter.prompt(prompt))
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
