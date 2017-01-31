// Menu.swift Created by mason on 2017-01-20.


/// Menu manages a collection of values, presenting a text UI and running a user input loop until the user accepts the results. Menus are configured, then executed with `run()`, which returns the menu's result. 
///
/// Simple named-value lists can be managed by default, and Menu can be extended (via custom initializers and custom MenuResultBuilder closures) to manage other kinds of data.

public class Menu {
    
    public var title: String? = nil
    
    public var headers: [String] = []
    
    public var content: [MenuItem] = []
    
    public var footers: [String] = []

    public var prompt: String? = nil
    
    public var interface: MenuInterface = DefaultMenuInterface()
    
    public init(title: String? = nil) {
        self.title = title
    }
    
   
    /// Returns the result of running the menu. Running the menu means presenting its contents via the menu interface (normally, to allow editing), repeating in a loop, until complete.
    
    public func run() -> Any? {
        
        if let title = title {
            interface.writeTitle(title)
        }
        
        for header in headers {
            interface.writeHeader(header)
        }
        
        interface.writeContent(content)
        
        for footer in footers {
            interface.writeFooter(footer)
        }
        
        interface.writePrompt(prompt ?? defaultPrompt)

        
        let input = interface.read()
        
        if input == "" {
            return menuResult
        } else if let menuItem = self[input] {
            menuItem.run(interface:interface)
        } else {
            interface.write("Sorry, '\(input)' is not something I understand.")
        }
        return run()
    }
    

    /// By default, a menu's result is just the `values` dictionary. Those are always Strings, and easy to work with. However, in some cases it's convenient to make a Menu instance smart enough to return some kind of arbitrary object. A way to do that is to set the `menuResult` property to a custom routine (and a convenient place to do that would be your custom initializer that knows how to init with that same type of object).

    public var menuResult: Any? {
        
        if let builder = resultBuilder {
            return builder(self)
        } else {
            return values
        }
    }
    
    
    public var resultBuilder: MenuResultBuilder? = nil
    
 
    /// Returns a dictionary of named values, representing the current contents of the menu. By default, this object is the result returned by `run()` (although that can be overridden by setting the `resultBuilder` property.
    
    public var values: [String:String] {
        
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
    
    
    internal var defaultPrompt: String {
        
        return (content.count > 0)
            ? "Choose from menu, or press ↩︎ to accept current values:\n\n>"
            : "Press ↩︎ to continue:\n\n>"
    }
}


/// Type for Menu's `resultBuilder` property; it converts a menu('s values) into some arbitrary object.

public typealias MenuResultBuilder = ((Menu)->Any)


extension Menu {
    
    /// Initializes a Menu instance from a TargetHostValues instance.
    
    public convenience init(targetHostValues: TargetHostValues) {
    
        self.init()
        self.title = "TARGET HOST VALUES:"
        
        self.headers = [
            "The target host values specify the machine to be configured."
        ]
        
        // Just for fun, I am gonna validate the SSH port here. 
        let sshPortValidator: MenuItemValidator = { stringValue in
            let result = Int(stringValue) != nil
            print("SSH port validator result: \(result)")
            return result
        }
        
        self.content = [
            MenuItem("hostname", value: targetHostValues.hostname),
            MenuItem("sshPort", value: targetHostValues.sshPort, validator: sshPortValidator),
            MenuItem("username", value: targetHostValues.username),
            MenuItem("sshKeyPath", value: targetHostValues.sshKeyPath),
        ]
        
        self.resultBuilder = { menu in
            let v = self.values
            return TargetHostValues(hostname: v["hostname"], username: v["username"], sshPort: v["sshPort"], sshKeyPath: v["sshKeyPath"])
        }
    }
}


extension Menu {
    
    /// Initializes a Menu instance from a DerpValList instance.

    public convenience init(list: DerpValList) {
        
        self.init()
        self.title = "DEPLOY VALUES:" // FIXME: give DerpValList a name property, then use it here.
        
        self.headers = [
            "Edit the deploy values to control how the target machine is configured."
        ]

        var menuItems: [MenuItem] = []
        
        for dv in list.derpVals {
            let item = MenuItem(dv.identifier, value: (dv.value as? String) ?? "")
            menuItems.append(item)
        }
        self.content = menuItems
    }
}
