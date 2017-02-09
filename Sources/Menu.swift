// Menu.swift Created by mason on 2017-01-20.


/// Menu manages a collection of values, presenting a text UI and running a user input loop until the user accepts the results. Menus are configured, then executed with `run()`, which returns the menu's result. 
///
/// Simple named-value lists can be managed by default, and Menu can be extended (via custom initializers and custom MenuResultBuilder closures) to manage other kinds of data.

/*
 
 NOTES:
 
 Menus:
 - do UI and return a list of named values
 - do UI return a single value
 - just do UI, optionally doing some action, and return nothing
 
 What I don't like is how the Menu class also *manages* the state of this list of named values. Somebody else should do the managing and just let Menu deal with the UI I/O....
 
 And I don't like how MenuItem 
 
 */

public class Menu: MenuInterlocutor {
    
    public var title: String? = nil
    
    public var headers: [String] = []
    
    public var content: [MenuItem] = []
    
    public var footers: [String] = []

    public var prompt: String? = nil
    
    public var interface: MenuInterface = DefaultMenuInterface()
    
    
    public init(title: String? = nil, content: [MenuItem]? = nil, interface: MenuInterface? = nil) {
        
        self.title = title
        if let content = content {
            self.content = content
        }
        if let interface = interface {
            self.interface = interface
        }
    }
    
    
    public convenience init(menuItem: MenuItem, title: String? = nil, interface: MenuInterface? = nil) {
        
        self.init(title: title, interface: interface)

        if let predefinedValues = menuItem.predefinedValues {
            for val in predefinedValues {
                content.append(MenuItem(staticValue: val))
            }
        }
        
        switch menuItem.type {
        
        case .boolean:
            fatalError("menu init from bool not yet implemented")
        
        case .string:
            if content.count > 0 {
                content.append(MenuItem("other value", value: "", type: .userInput))
                prompt = promptChooseOrEnterValue()
            } else {
                prompt = messageAcceptOrManuallyChangeValue(name: menuItem.name, value: menuItem.stringValue)
            }
            
        case .predefined:
            prompt = promptChooseFromMenuOrAcceptCurrent(name: menuItem.name, value: menuItem.stringValue)
            
        case .staticValue:
            fatalError("menu init from .staticValue not yet implemented")

        case .userInput:
            prompt  = promptManuallyEnterNewValueOrAcceptCurrent(name: menuItem.name, value: menuItem.stringValue)
        }
        
        self.inputHandler = { input, menu in
            
            if (input == "") {
                // So far, at least, this always means "no change".
                self.interface.write(self.messageNoChangeMade())
                return menuItem.value
            }
            
            var actualInput = input

            if let itemSelected = self[input] {
                actualInput = itemSelected.run(interface: self.interface).toString()
            }
            
            if menuItem.validate(actualInput) {
                menuItem.value = actualInput.makeMenuItemValue(type: menuItem.type)
                let changeMessage = self.messageValueChanged(name: menuItem.name, newValue: menuItem.stringValue)
                self.interface.writeResultsMessage(changeMessage)
                return menuItem.value
                
            } else {
                let nope = self.messageBadInputPleaseTryAgain(input: input)
                interface?.writeResultsMessage(nope)
                return self.run()
            }
        }
    }
    
    
    
    /// Returns the result of running the menu. Running the menu means presenting its contents via the menu interface (normally, to allow editing), repeating in a loop, until complete.
    
    public func run(resultsMessage: String? = nil) -> Any? {
        
        if let resultsMessage = resultsMessage {
            interface.writeResultsMessage(resultsMessage)
        }
        
        if let title = title {
            interface.writeTitle(title)
        }
        
        for header in headers {
            interface.writeHeader(header)
        }
        
        if content.count > 0 {
            // test to avoid writing useless "" which impairs testability
            interface.writeContent(content)
        }
        
        for footer in footers {
            interface.writeFooter(footer)
        }
        
        interface.writePrompt(prompt ?? defaultPrompt)

        
        let input = interface.read()
        
        if let handler = inputHandler {
            
            // If self.inputHandler exists, then it is solely responsible for dealing with the input, which
            // means either returning a value, or displaying something like "sorry, try again" and running 
            // the menu again recursively. See the else clause below for an example of what to do.
            
            return handler(input, self)
        
        } else {
            
            if input == "" {
                
                return menuResult
                
            } else if let menuItem = self[input] {
                
                _ = menuItem.run(interface:interface)

            } else {
                
                interface.write("Sorry, '\(input)' is not something I understand.")
            }
            return run()
        }
    }
    
    
    public var inputHandler: MenuInputHandler? = nil
    
    

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
            result[menuItem.name] = menuItem.value.toString()
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

/// Type for Menu's `inputHandler` property; it takes over all input-handling responsibilities A return value of nil indicates that the menu should reject the input and run again. Any non-nil return value becomes the menu's result.

public typealias MenuInputHandler = ((_ input: String, _ menu: Menu)->Any?)


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
