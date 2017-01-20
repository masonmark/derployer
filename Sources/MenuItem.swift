// MenuItem.swift Created by mason on 2017-01-20. 

import Foundation

public class MenuItem {
    
    public var value: String?
    
    public var name: String
    
    public init(_ name: String, value: String? = nil) {
        self.name  = name;
        self.value = value;
    }
}
