// Menu.swift Created by mason on 2017-01-20.


/// Menu manages a value, or a collection of values, presenting a text UI and running a user input loop until the user accepts the results. Menus are configured, then executed with `run()`, which returns the menu's result.
///
/// Simple named-value lists can be managed by default, and Menu can be extended (via custom initializers and custom MenuResultBuilder closures) to manage other kinds of data.

public class Menu: MenuInterlocutor {
    
    public var title: String? = nil
    
    public var headers: [String] = []
    
    public var content: MenuItemList = MenuItemList()
    
    public var footers: [String] = []

    public var prompt: String? = nil
    
    public var interface: MenuInterface = DefaultMenuInterface()
    
    /// Allows certain menus to short-circuit the run() process, without actually asking for input.
    private var preordainedValue: MenuValue? = nil
    
    private var menuItem: MenuItem? = nil
    
    
    public init(title: String? = nil, content: MenuItemList? = nil, interface: MenuInterface? = nil) {
        
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
        
        self.menuItem = menuItem
        
        switch menuItem.type {
        
        case .boolean:
            preordainedValue = !menuItem.boolValue
        
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
            preordainedValue = menuItem.value

        case .userInput:
            prompt  = promptManuallyEnterNewValueOrAcceptCurrent(name: menuItem.name, value: menuItem.stringValue)
        }
    }
    
    
    
    
    /// Returns the result of running the menu. Running the menu means presenting its contents via the menu interface (normally, to allow editing), repeating in a loop, until complete. (Some menu item types have preordained results — merely selecting the item does something (e.g. toggle a .boolean, or return the immutable value of a .staticValue typed MenuItem. In those cases, input isn't actually read from the menu interface.)
    
    public func run(resultsMessage: String? = nil) -> MenuValue? {
        
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
            interface.writeContent(content.menuItems)
        }
        
        for footer in footers {
            interface.writeFooter(footer)
        }
        
        if let result = preordainedValue {
            // We do this AFTER printing title, headers, etc...
            
            guard let item = menuItem else {
                fatalError("🐜 preordainedValue implies self.menuItem != nil, but it's nil")
            }
            item.value = result
            return result
        }
        
        interface.writePrompt(prompt ?? defaultPrompt)

        let input = interface.read()
        
        if let handler = inputHandler {
            
            // If self.inputHandler exists, then it is solely responsible for dealing with the input, which
            // means either returning a value, or displaying something like "sorry, try again" and running 
            // the menu again recursively. See the else clause below for an example of what to do.
            
            return handler(input, self)
        
        } else {
            
            guard let menuItem = menuItem else {
                return process(input: input)
            }
            return process(input: input, forMenuItem:menuItem)
        }
    }
    
    
    /// The default input processing for when the menu IS NOT a submenu of a MenuItem, so it is processing input for itself (assumption here is that this is a root menu with a list of menu items.
    
    public func process(input: String) -> MenuValue? {
        
        if input == "" {
            
            /// By default, a menu's result is just the `content` property (a MenuItemList, which can be used as a list of named values). For a simple list of values, that's easy to work with. However, in some cases it's convenient to make a Menu instance smart enough to return some kind of arbitrary object. A way to do that is to set the `resultBuilder` property to a custom routine (and a convenient place to do that would be your custom initializer that knows how to init with that same type of object). (Your object's type will also need to conform to MenuValue.)

            if let builder = resultBuilder {
                return builder(self)
            } else {
                return content
            }
            
        } else if let menuItem = self[input] {
            let submenu = Menu(menuItem: menuItem, interface: interface)
            
            _ = submenu.run()
            // Here we run the menu for the menu item, for its side effect of updating the value of the menu item, but we don't return that value, and instead run the receiver again after doing that. This is sort of surprising, and it is a legacy of my first design of the menu system, which kind of totally sucked balls, so FIXME bro...
        } else {
            interface.write("Sorry, '\(input)' is not something I understand.")
        }
        return run()
    }
    
    /// The default input processing for when the menu IS a submenu of a MenuItem.
    
    public func process(input: String, forMenuItem menuItem: MenuItem) -> MenuValue? {
        
        if (input == "") {
            // So far, at least, this always means "no change".
            interface.write(messageNoChangeMade())
            return menuItem.value
        }
        
        var actualInput = input
        
        if let itemSelected = self[input] {
            
            let submenu       = Menu(menuItem: itemSelected, interface: interface)
            let submenuResult = submenu.run()
            
            guard let submenuVal = submenuResult else {
                fatalError("BAD IMPLEMENTATION BRO")
            }
            actualInput = submenuVal.toString()
            // FIXME: THIS IS NOT GOOD. HOW TO FIX IT IS MAKE Menu.run() return MenuValue? I think...
        }
        if menuItem.validate(actualInput) {
            
            menuItem.value = actualInput.makeMenuValue(type: menuItem.type)
            let changeMessage = self.messageValueChanged(name: menuItem.name, newValue: menuItem.stringValue)
            self.interface.writeResultsMessage(changeMessage)
            return menuItem.value
        } else {
            let nope = self.messageBadInputPleaseTryAgain(input: input)
            interface.writeResultsMessage(nope)
            return self.run()
        }
    }
    
    
    public var inputHandler: MenuInputHandler? = nil
    
    public var resultBuilder: MenuResultBuilder? = nil
    
    
    /// Returns the corresponding MenuItem instance if `selection` is a number that is one of the menu's choices, otherwise nil.
    
    public subscript(selection: String) -> MenuItem? {
        
        // FIXME: Mason 2017-02-12: It's noted in a couple of the tests, but this shoudl be extended to allow myMenu["foo"] (look up menu item via its string name)
        
        guard let number = Int(selection) else {
            return nil
        }
        guard number > 0 && number <= content.count else {
            return nil
        }
        return content.menuItems[number - 1]
    }
    
    
    internal var defaultPrompt: String {
        
        return (content.count > 0)
            ? "Choose from menu, or press ↩︎ to accept current values:\n\n>"
            : "Press ↩︎ to continue:\n\n>"
    }
}


/// Type for Menu's `resultBuilder` property; it converts a menu('s values) into some arbitrary object.

public typealias MenuResultBuilder = ((Menu)->MenuValue)

/// Type for Menu's `inputHandler` property; it takes over all input-handling responsibilities A return value of nil indicates that the menu should reject the input and run again. Any non-nil return value becomes the menu's result.

public typealias MenuInputHandler = ((_ input: String, _ menu: Menu)->MenuValue?)
