// DeployPhase.swift Created by mason on 2017-02-05.

import Foundation

public final class DeployPhase: DerpSerializable {
    
    var title = "Untitled Deploy Phase"
    
    var menuItems: [MenuItem] = []

    
    public init() {
        
    }
    
    
    private struct SerializationKeys {
        static let values = "values"
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
        
        guard let a = values[SerializationKeys.values] as? [[String: Any?]] else {
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
}


extension Menu {
    
    public convenience init(deployPhase: DeployPhase) {
        self .init(title: deployPhase.title, content: deployPhase.menuItems)
    }
}
