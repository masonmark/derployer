// MenuItemList.swift Created by mason on 2017-02-05.

import Foundation

/// A list of MenuItem, wrapped in a concrete type so it can implement MenuValue. Probably this should be renamed someday to something like "named value list"...

public class MenuItemList: DerpSerializable, MenuValue /* , ExpressibleByArrayLiteral*/ {
    
    
    public var title = "Untitled List"
    
    
    public var menuItems: [MenuItem] = []

    
    required public init() {
        // satisfy swift compiler (due to DerpSerializable)
    }
    
    
    public convenience init(menuItems: [MenuItem]) {
        self.init()
        self.menuItems = menuItems
    }
    

    public func serialize() throws -> DerpSerializationValues {
        
        var list: [[String: Any?]] = []
        
        for item in menuItems {
            let dict = try item.serialize()
            list.append(dict)
        }
        
        return [
            SerializationKeys.values : list
        ]
    }
    
    
    public func deserialize(_ values: DerpSerializationValues) throws {
        
        guard let a = values[SerializationKeys.values] as? [[String: Any]] else {
            throw DerpSerializableError.DeserializationFailed("invalid data: no 'values' found at top level")
        }
        
        menuItems = []
        
        for dict in a {
            guard let item = MenuItem(serializationValues:dict) else {
                throw DerpSerializableError.DeserializationFailed("invalid data: \(dict)")
            }
            menuItems.append(item)
        }
    }
    
    
    private struct SerializationKeys {
        static let values = "values"
    }
    
    
    public subscript(key: String) -> MenuItem? {
        
        get {
            for x in menuItems {
                if x.name == key {
                    return x
                }
            }
            return nil
        }        
    }
    
    
    public var count: Int {
        return menuItems.count
    }
    
    
    public func append(_ item: MenuItem) {
        menuItems.append(item)
    }
    
    
    // MARK: - MenuValue
    // Cannot put these in extensions, because then in subclass compiler barfs: 
    // "Declarations from extensions cannot be overridden yet"
    
    public func toString() -> String {
        
        return JSON
    }
    
    public func updateFrom(string: String) -> Bool {
        
        let myClass = type(of: self)
        guard let other = myClass.init(json: string) else {
            return false
        }
        self.title     = other.title
        self.menuItems = other.menuItems
        return true
    }
}


extension Menu {
    
    public convenience init(list: MenuItemList) {
        self .init(title: list.title, content: list)
    }
}
