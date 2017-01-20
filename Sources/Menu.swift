// Menu.swift Created by mason on 2017-01-20.

import Foundation

public class Menu {
    
    public var title: String? = nil
    
    public var content: [MenuItem] = []
    
    public var interface: MenuInterface = TestMenuInterface()
    
    public var formatter: MenuFormatter = DefaultMenuFormatter()
    
    init(title: String? = nil) {
        self.title = title
    }
    
    public func run() {
        if let title = title {
            interface.write(formatter.title(title))
        }
        interface.write(formatter.content(content))
        interface.write("Choose from menu, or press ↩︎ to accept current values:\n\n>", terminator: "")
    }
}
