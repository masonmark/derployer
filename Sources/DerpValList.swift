// DerpValList.swift Created by mason on 2017-01-29

import Foundation


/// A list of derp vals, which defines the values used for a deploy phase.

final public class DerpValList: DerpSerializable {

    var derpVals: [DerpVal] = []
    
    public init() {
        
    }
    
    public convenience init(_ derpVals: [DerpVal]) {
        self.init()
        self.derpVals = derpVals
    }
    
    public func serialize() throws -> DerpSerializationValues {
        
        var list: [[String: Any?]] = []
        
        for dv in derpVals {
            let dict = try dv.serialize()
            list.append(dict)
        }
        
        return [
            key(.values) : list
        ]
    }
    
    
    public func deserialize(_ values: DerpSerializationValues) throws {
        
        guard let a = values[key(.values)] as? [[String: Any?]] else {
            throw DerpSerializableError.DeserializationFailed("invalid data: no values found")
        }
        
        derpVals = []
        
        for dict in a {
            guard let dv = DerpVal(serializationValues:dict) else {
                throw DerpSerializableError.DeserializationFailed("invalid data: \(dict)")
            }
            derpVals.append(dv)
        }
    }
}


public enum DerpValListKey: String {
    case values
}


extension DerpValList {
    
    public static func key(_ key: DerpValListKey) -> String {
        return key.rawValue
    }
    public func key(_ key: DerpValListKey) -> String {
        return key.rawValue
    }
}
