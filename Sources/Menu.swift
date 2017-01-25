// Menu.swift Created by mason on 2017-01-20.


public class Menu {
    
    public var title: String? = nil
    
    public var headers: [String] = []
    
    public var footers: [String] = []
    
    public var content: [MenuItem] = []
    
    public var interface: MenuInterface = DefaultMenuInterface()
    
    public var formatter: MenuFormatter = DefaultMenuFormatter()
    
    
    init(title: String? = nil) {
        self.title = title
    }
    
    
    public func run() {
        
        if let title = title {
            interface.write(formatter.title(title))
        }
        
        for header in headers {
            interface.write(formatter.header(header))
        }
        
        interface.write(formatter.content(content))
        
        for footer in footers {
            interface.write(formatter.footer(footer))
        }
        
        interface.write("Choose from menu, or press ↩︎ to accept current values:\n\n>", terminator: "")
        // FIXME: above should be configurable footer
        
        let input = interface.read()
        
        if input == "" {
            return
        } else if let menuItem = self[input] {
            menuItem.run(interface:interface)
        } else {
            interface.write("Sorry, '\(input)' is not something I understand.")
        }
        run()
    }
    
    
    public func values() -> [String:String] {
        var result: [String:String] = [:]
        for menuItem in content {
            result[menuItem.name] = menuItem.value
        }
        return result;
    }
    
    
    /// Returns the corresponding MenuItem instance if `selection` is a number that is one of the menu's choices, otherwise nil.
    
    public subscript(selection: String) -> MenuItem? {
        guard let number = Int(selection) else {
            return nil
        }
        guard number > 0 && number <= content.count else {
            return nil
        }
        return content[number - 1]
    }
    
}


extension Menu {
    
    convenience init(targetHostValues: TargetHostValues) {
    
        self.init()
        self.title = "TARGET HOST VALUES:"
        
        self.headers = [
            "The target host values specify the machine to be configured."
        ]
        
        self.content = [
            MenuItem("hostname", value: targetHostValues.hostname),
            MenuItem("sshPort", value: targetHostValues.sshPort),
            MenuItem("username", value: targetHostValues.username),
            MenuItem("sshKeyPath", value: targetHostValues.sshKeyPath),
        ]
    }
}
