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
    
    public var inputs: [String]
    public var outputs: [String]
    
    /// If true, will print() both inputs and outputs so tests can be visually debugged.
    public var shouldPrint: Bool = false
    
    public init(inputs: [String] = [], outputs: [String] = [], shouldPrint: Bool = false) {
        
        self.inputs      = inputs
        self.outputs     = outputs
        self.shouldPrint = shouldPrint
    }
    
    public func read() -> String {
        
        guard self.inputs.count > 0 else {
            if shouldPrint {
                print("")
            }
            return ""
        }
        let result = self.inputs.remove(at: 0)
        if shouldPrint {
            print(result)
        }
        return result
    }
    
    public func write(_ output: String) {
        
        if shouldPrint {
            print(output)
        }
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
            return "EOF ︵ヽ(`Д´)ﾉ︵ NOT YET SUPPORTED" // Hmm...
        }
        return result
    }
    
    public func write(_ output: String) {
        print(output)
    }
}
